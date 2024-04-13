#!/bin/bash

echo "Starting Stolon as a $ROLE..."

case "$ROLE" in
  "keeper")
    exec stolon-keeper --data-dir /stolon-data --cluster-name $STOLONCTL_CLUSTER_NAME --store-backend $STOLONCTL_STORE_BACKEND --store-endpoints $STOLONCTL_STORE_URL
    ;;
  "sentinel")
    exec stolon-sentinel --cluster-name $STOLONCTL_CLUSTER_NAME --store-backend $STOLONCTL_STORE_BACKEND --store-endpoints $STOLONCTL_STORE_URL
    ;;
  "proxy")
    exec stolon-proxy --cluster-name $STOLONCTL_CLUSTER_NAME --store-backend $STOLONCTL_STORE_BACKEND --store-endpoints $STOLONCTL_STORE_URL
    ;;
  *)
    echo "Unknown role: $ROLE"
    exit 1
    ;;
esac