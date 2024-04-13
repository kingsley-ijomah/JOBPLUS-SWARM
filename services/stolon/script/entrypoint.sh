#!/bin/bash
set -e

# Default to run as keeper if not specified
ROLE=${ROLE:-keeper}

echo "Starting Stolon as a $ROLE..."

case "$ROLE" in
    "keeper")
        exec stolon-keeper --data-dir /stolon-data --cluster-name ${STOLONCTL_CLUSTER_NAME} --store-backend ${STOLONCTL_STORE_BACKEND} --store-endpoints ${STOLONCTL_STORE_URL}
        ;;
    "sentinel")
        exec stolon-sentinel --cluster-name ${STOLONCTL_CLUSTER_NAME} --store-backend ${STOLONCTL_STORE_BACKEND} --store-endpoints ${STOLONCTL_STORE_URL}
        ;;
    "proxy")
        exec stolon-proxy --listen-address 0.0.0.0 --port 5432 --cluster-name ${STOLONCTL_CLUSTER_NAME} --store-backend ${STOLONCTL_STORE_BACKEND} --store-endpoints ${STOLONCTL_STORE_URL}
        ;;
    *)
        echo "Unknown role: $ROLE"
        exit 1
        ;;
esac