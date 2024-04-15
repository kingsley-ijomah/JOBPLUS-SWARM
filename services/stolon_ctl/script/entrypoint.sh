#!/bin/bash
set -e

# Function to check if the cluster is already initialized
cluster_initialized() {
    stolonctl status --cluster-name stolon-cluster --store-backend etcd --store-endpoints http://etcd:2379 &> /dev/null
    return $?
}

# Initialize the cluster if it's not already initialized
if ! cluster_initialized; then
    echo "Initializing Stolon cluster..."
    stolonctl init --cluster-name stolon-cluster --store-backend etcd --store-endpoints http://etcd:2379 --yes
else
    echo "Stolon cluster already initialized."
fi

# Keep the container running after initialization
exec "$@"