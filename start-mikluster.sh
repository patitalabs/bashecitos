#!/bin/bash

if [[ $# -ne 1 ]]; then 
    echo "Usage: $0 cluster-profile-name"
    exit 1
fi 

KLUSTER_PROFILE_NAME=$1
MIKLUSTER_START_EC=$(minikube start --memory=8192 --cpus=3 --kubernetes-version=v1.21.3 --vm-driver=virtualbox -p "${KLUSTER_PROFILE_NAME}")
exit "${MIKLUSTER_START_EC}"