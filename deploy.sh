#!/bin/bash
#set -e

# replace the parameter below with your designated cluster context
# note that the character '_' is an invalid value
#
# please use `kubectl config rename-contexts <current_context> <target_context>` to
# rename your context if necessary
LICENSE_KEY=${1:-""}
cluster_context=${2:-mgmt}
environment_overlay=${3:-prod} # prod, qa, dev, base

# check to see if defined contexts exist
if [[ $(kubectl config get-contexts | grep ${cluster_context}) == "" ]] ; then
  echo "Check Failed: ${cluster_context} context does not exist. Please check to see if you have the clusters available"
  echo "Run 'kubectl config get-contexts' to see currently available contexts. If the clusters are available, please make sure that they are named correctly. Default is ${cluster_context}"
  exit 1;
fi

# create license
./tools/create-license.sh "${LICENSE_KEY}" "${cluster_context}"

# install argocd
cd bootstrap-argocd
./install-argocd.sh insecure-rootpath ${cluster_context}
cd ..

# wait for argo cluster rollout
./tools/wait-for-rollout.sh deployment argocd-server argocd 20 ${cluster_context}

# deploy app of app waves
for i in $(ls -l environment/ | grep -v ^total | awk '{print $9}'); do 
  echo "starting ${i}"
  # run init script if it exists
  [[ -f "environment/${i}/init.sh" ]] && ./environment/${i}/init.sh ${i} ${environment_overlay}
  # deploy aoa wave
  ./tools/configure-wave.sh ${i} ${environment_overlay} ${cluster_context}
  # run test script if it exists
  [[ -f "environment/${i}/test.sh" ]] && ./environment/${i}/test.sh
done

echo "END."

