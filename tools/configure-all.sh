#!/bin/bash
#set -e

# source vars from root directory vars.txt
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/../vars.txt

# check to see if cluster context variable was passed through, if not prompt for it
if [[ ${cluster_context} == "" ]]
  then
    # provide cluster context overlay
    echo "Please provide the cluster context to use (i.e. mgmt, cluster1, cluster2):"
    read cluster_context
fi

# check to see if environment overlay variable was passed through, if not prompt for it
if [[ ${environment_overlay} == "" ]]
  then
    # provide environment overlay
    echo "Please provide the environment overlay to use (i.e. prod, dev, qa):"
    read environment_overlay
fi

# configure
for i in $(ls ../environment | sort -n); do 
  echo "starting ${i}"
  # deploy aoa wave
  ./configure-wave.sh ${i} ${environment_overlay} ${cluster_context} ${github_username} ${repo_name} ${target_branch}
done
