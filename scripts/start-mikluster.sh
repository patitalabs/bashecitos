#!/bin/bash

start_minikube_cluster(){
    KLUSTER_PROFILE_NAME=$1

    echo "Going to start minikube cluster with profile name ${KLUSTER_PROFILE_NAME} 🌱"

    minikube start --memory=8192 --cpus=3 --kubernetes-version=v1.21.3 --vm-driver=virtualbox -p "${KLUSTER_PROFILE_NAME}"

    CLUSTER_STARTED=$?

    if [[ $CLUSTER_STARTED -eq 0 ]]; then 
        echo "The minikube cluster ${KLUSTER_PROFILE_NAME} is started 🎉"
    fi
}

check_docker_is_running_and_wait(){
    IS_DOCKER_RUNNING=$(docker stats --no-stream 2>/dev/null)

    if [[ ! ${IS_DOCKER_RUNNING} ]]; then
        open /Applications/Docker.app/
    fi

    while [[ ! ${IS_DOCKER_RUNNING} ]]; do
        IS_DOCKER_RUNNING=$(docker stats --no-stream 2>/dev/null)
        sleep 2
    done
}

# Check that a name for the cluster profile was provided
if [[ $# -ne 1 ]]; then 
    echo "Usage: $0 cluster-profile-name"
    exit 1
fi 

# Having the Docker daemon running is a prerequisite to start a minikube cluster
# So, first we check that the Docker is running and if it's not, we wait until it is running.
check_docker_is_running_and_wait

start_minikube_cluster "${1}"