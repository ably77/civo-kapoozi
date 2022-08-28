#!/bin/bash
#set -e

environment_overlay=${1:-prod} # prod, qa, dev
# number of app waves in the environments directory
environment_waves="$(ls ../environment | wc -l)"

# configure
for i in $(seq ${environment_waves}); do 
  kubectl apply -f ../environment/wave-${i}/${environment_overlay}/wave-${i}-aoa.yaml;
done