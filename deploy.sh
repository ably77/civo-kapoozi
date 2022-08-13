#!/bin/bash
#set -e

# replace the parameter below with your designated cluster context
# note that the character '_' is an invalid value
#
# please use `kubectl config rename-contexts <current_context> <target_context>` to
# rename your context if necessary
cluster_context="mgmt"
# number of app waves in the environments directory
environment_waves="4"


# check to see if defined contexts exist
if [[ $(kubectl config get-contexts | grep ${cluster_context}) == "" ]] ; then
  echo "Check Failed: ${cluster_context} context does not exist. Please check to see if you have the clusters available"
  echo "Run 'kubectl config get-contexts' to see currently available contexts. If the clusters are available, please make sure that they are named correctly. Default is ${cluster_context}"
  exit 1;
fi

# add this back when upgrading to 2.1.x
#LICENSE_KEY="$1"
## check to see if license key variable was passed through, if not prompt for key
#if [[ ${LICENSE_KEY} == "" ]]
#  then
#    # provide license key
#    echo "Please provide your Gloo Mesh Enterprise License Key:"
#    read LICENSE_KEY
#fi
#
## check OS type
#if [[ "$OSTYPE" == "linux-gnu"* ]]; then
#        # Linux
#        BASE64_LICENSE_KEY=$(echo -n "${LICENSE_KEY}" | base64 -w 0)
#elif [[ "$OSTYPE" == "darwin"* ]]; then
#        # Mac OSX
#        BASE64_LICENSE_KEY=$(echo -n "${LICENSE_KEY}" | base64)
#else
#        echo unknown OS type
#        exit 1
#fi
#
## license stuff
#kubectl create ns gloo-mesh --context ${cluster_context}
#
#kubectl apply --context ${cluster_context} -f - <<EOF
#apiVersion: v1
#data:
#  gloo-mesh-license-key: ${BASE64_LICENSE_KEY}
#kind: Secret
#metadata:
#  name: gloo-mesh-license
#  namespace: gloo-mesh
#type: Opaque
#EOF

# install argocd
cd bootstrap-argocd
./install-argocd.sh insecure-rootpath ${cluster_context}
cd ..

# wait for argo cluster rollout
./tools/wait-for-rollout.sh deployment argocd-server argocd 20 ${cluster_context}

# deploy app of app waves
for i in $(seq ${environment_waves}); do 
  #echo $i;
  kubectl apply -f environment/wave-${i}/wave-${i}-aoa.yaml --context ${cluster_context};
  #TODO: add test script if statement
  sleep 20; 
done

# wait for completion of gloo-mesh install
./tools/wait-for-rollout.sh deployment gloo-mesh-mgmt-server gloo-mesh 10 ${cluster_context}

# echo port-forward commands
echo
echo "access gloo mesh dashboard:"
echo "kubectl port-forward -n gloo-mesh svc/gloo-mesh-ui 8090 --context ${cluster_context}"
echo 
echo "access argocd dashboard:"
echo "kubectl port-forward svc/argocd-server -n argocd 9999:443 --context ${cluster_context}"
echo
echo "navigate to http://localhost:8090 in your browser for the Gloo Mesh UI"
echo "navigate to http://localhost:9999/argo in your browser for argocd"
echo
echo "username: admin"
echo "password: solo.io"
