#!/bin/bash

cluster_context="mgmt"


./tools/wait-for-rollout.sh deployment gloo-mesh-mgmt-server gloo-mesh 10 ${cluster_context}

