#!/bin/bash
#set -e

wave_name=${1:-""}
environment_overlay=${2:-prod} # prod, qa, dev, base
cluster_context=${3:-mgmt}
github_username=${4:-ably77}
repo_name=${5:-civo-kapoozi}
target_branch=${6:-HEAD}

# check to see if wave name variable was passed through, if not prompt for it
if [[ ${wave_name} == "" ]]
  then
    # provide license key
    echo "Please provide the wave name:"
    read wave_name
fi

kubectl --context ${cluster_context} apply -f - <<EOF
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: wave-${wave_name}-aoa
  namespace: argocd
  finalizers:
  - resources-finalizer.argocd.argoproj.io
spec:
  project: default
  source:
    repoURL: https://github.com/${github_username}/${repo_name}/
    targetRevision: ${target_branch}
    path: environment/${wave_name}/${environment_overlay}/active/
  destination:
    server: https://kubernetes.default.svc
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
EOF