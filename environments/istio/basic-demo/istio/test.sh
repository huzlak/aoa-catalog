#!/bin/bash

$SCRIPT_DIR/tools/wait-for-rollout.sh deployment istio-ingressgateway istio-system 10 ${cluster_context}
#$SCRIPT_DIR/tools/wait-for-rollout.sh deployment istio-eastwestgateway-1-19 istio-eastwest 10 ${cluster_context}