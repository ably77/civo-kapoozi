#!/bin/bash
#set -e

# replace the parameter below with your designated cluster context
# note that the character '_' is an invalid value
#
# please use `kubectl config rename-contexts <current_context> <target_context>` to
# rename your context if necessary
cluster_context=${1:-mgmt}
environment_overlay=${2:-""} # prod, qa, dev, base

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
  ./configure-wave.sh ${i} ${environment_overlay} ${cluster_context}
done
