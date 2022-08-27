#!/bin/bash

cluster_context="mgmt"

./tools/wait-for-rollout.sh deployment blog collaboration-tools 10 ${cluster_context}