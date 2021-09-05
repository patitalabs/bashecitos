#!/bin/bash

# The goal of this script is to create and start a minikube cluster on macOS host.
# It receives as input the cluster profile name. 

set -e

start_minikube_cluster(){
    KLUSTER_PROFILE_NAME=$1

    echo "Going to start minikube cluster with profile name: ${KLUSTER_PROFILE_NAME} 🌱"

    minikube start --memory=8192 --cpus=3 --kubernetes-version=v1.21.3 --vm-driver=virtualbox -p "${KLUSTER_PROFILE_NAME}"

    CLUSTER_STARTED=$?

    if [[ $CLUSTER_STARTED -eq 0 ]]; then 
        echo "The minikube cluster ${KLUSTER_PROFILE_NAME} is up and running 🎉 and it's status is:"
        echo "minikube status -p ${KLUSTER_PROFILE_NAME}"
        minikube status -p "${KLUSTER_PROFILE_NAME}"

        # Showing how to point your shell to minikube's docker-daemon
        minikube -p "${KLUSTER_PROFILE_NAME}" docker-env | tail -2

        echo " "
        echo "# To stop minikube, run:"
        echo "# minikube stop -p ${KLUSTER_PROFILE_NAME}"
    fi
}

# Check that a name for the cluster profile was provided
if [[ $# -ne 1 ]]; then 
    echo "Usage: $0 cluster-profile-name"
    exit 1
fi 

start_minikube_cluster "${1}"