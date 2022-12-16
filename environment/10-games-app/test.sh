#!/bin/bash

# wait for completion of httpbin install
./tools/wait-for-rollout.sh deployment supermario supermario 10 ${cluster_context}