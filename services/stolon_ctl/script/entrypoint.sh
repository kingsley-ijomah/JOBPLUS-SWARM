#!/bin/bash
set -e

# Function to check if the cluster is already initialized
cluster_initialized() {
    stolonctl status --cluster-name=stolon-cluster --store-backend=consul --store-endpoints=http://consul:8500 &> /dev/null
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
    # This command initializes the Stolon cluster configuration in the etcd database. It sets up the necessary 
    # data structures in etcd under the specified cluster name "stolon-cluster", using etcd as the backend storage.
    # This includes writing initial configuration and state data into etcd, which Stolon components will use for
    # managing the PostgreSQL cluster.
    stolonctl init --cluster-name=stolon-cluster --store-backend=consul --store-endpoints=http://consul:8500 --yes
else
    echo "Stolon cluster already initialized."
fi

# Keep the container running after initialization
exec "$@"
