#!/bin/bash
set -e

# Function to check if the cluster is already initialized
cluster_initialized() {
    stolonctl status --cluster-name=stolon-cluster --store-backend=consul --store-endpoints=http://consul:8500 &> /dev/null
    return $?
}

# Initialize the cluster if it's not already initialized
if ! cluster_initialized; then
    echo "Initializing Stolon cluster..."
    # This command initializes the Stolon cluster configuration in the consul database. It sets up the necessary 
    # data structures in consul under the specified cluster name "stolon-cluster", using consul as the backend storage.
    # This includes writing initial configuration and state data into consul, which Stolon components will use for
    # managing the PostgreSQL cluster.
    stolonctl init --cluster-name=stolon-cluster --store-backend=consul --store-endpoints=http://consul:8500 --yes
else
    echo "Stolon cluster already initialized."
fi

# Keep the container running after initialization
exec "$@"
