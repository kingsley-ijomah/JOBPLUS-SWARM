#!/bin/bash
set -e

# Function to check if the cluster is already initialized
cluster_initialized() {
    stolonctl status --cluster-name stolon-cluster --store-backend etcd --store-endpoints http://etcd:2379 &> /dev/null
    return $?
}

# Wait for etcd to become available
while ! nc -z etcd 2379; do
    echo 'Waiting for etcd to become available...'
    sleep 1
done
echo 'etcd is up and running!'

# Initialize the cluster if it's not already initialized
if ! cluster_initialized; then
    echo "Initializing Stolon cluster..."
    # stolonctl init --cluster-name stolon-cluster --store-backend etcd --store-endpoints http://etcd:2379 --yes
    # stolonctl init --yes
else
    echo "Stolon cluster already initialized."
fi

# Keep the container running after initialization
exec "$@"
