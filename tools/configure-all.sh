#!/bin/bash
#set -e

# replace the parameter below with your designated cluster context
# note that the character '_' is an invalid value
#
# please use `kubectl config rename-contexts <current_context> <target_context>` to
# rename your context if necessary
cluster_context=${1:-mgmt}
environment_overlay=${2:-prod} # prod, qa, dev, base

# configure
for i in $(ls -l ../environment/ | grep -v ^total | awk '{print $9}'); do 
  echo "starting ${i}"
  # deploy aoa wave
  ./configure-wave.sh ${i} ${environment_overlay} ${cluster_context}
done
