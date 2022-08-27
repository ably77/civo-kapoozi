#!/bin/bash
cluster_context="mgmt"

./tools/wait-for-rollout.sh deployment cert-manager cert-manager 10 ${cluster_context}