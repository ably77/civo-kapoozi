#!/bin/bash
#set -e

# source vars from root directory vars.txt
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/vars.txt

# check to see if defined contexts exist
if [[ $(kubectl config get-contexts | grep ${cluster_context}) == "" ]] ; then
  echo "Check Failed: ${cluster_context} context does not exist. Please check to see if you have the clusters available"
  echo "Run 'kubectl config get-contexts' to see currently available contexts. If the clusters are available, please make sure that they are named correctly. Default is ${cluster_context}"
  exit 1;
fi

# create license
./tools/create-license.sh "${LICENSE_KEY}" "${cluster_context}"

# check to see if environment overlay variable was passed through, if not prompt for it
if [[ ${environment_overlay} == "" ]]
  then
    # provide environment overlay
    echo "Please provide the environment overlay to use (i.e. prod, dev, qa):"
    read environment_overlay
fi

# install argocd
cd bootstrap-argocd
./install-argocd.sh insecure-rootpath ${cluster_context}
cd ..

# wait for argo cluster rollout
./tools/wait-for-rollout.sh deployment argocd-server argocd 20 ${cluster_context}

# deploy app of app waves
for i in $(ls environment | sort -n); do 
  echo "starting ${i}"
  # run init script if it exists
  [[ -f "environment/${i}/init.sh" ]] && ./environment/${i}/init.sh ${i} ${environment_overlay} ${cluster_context} ${github_username} ${repo_name} ${target_branch}
  # deploy aoa wave
  ./tools/configure-wave.sh ${i} ${environment_overlay} ${cluster_context}
  # run test script if it exists
  [[ -f "environment/${i}/test.sh" ]] && ./environment/${i}/test.sh
done

echo "END."

