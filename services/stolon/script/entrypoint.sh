#!/bin/bash

# Fetch the IP address of the container
IP_ADDRESS=$(hostname -I | awk '{print $1}')

echo "Starting Stolon as a $ROLE..."

case "$ROLE" in
  "ctl")
    echo "Checking if Stolon cluster is already initialized..."
    if stolonctl status --cluster-name $STOLONCTL_CLUSTER_NAME --store-backend $STOLONCTL_STORE_BACKEND --store-endpoints $STOLONCTL_STORE_URL; then
      echo "Stolon cluster already initialized."
    else
      echo "Initializing Stolon cluster..."
      stolonctl \
        --cluster-name $STOLONCTL_CLUSTER_NAME \
        --store-backend $STOLONCTL_STORE_BACKEND \
        --store-endpoints $STOLONCTL_STORE_URL \
        init --yes
      echo "Stolon cluster initialized."

      # Setting up WAL ( write-ahead log ) Archiving  
      echo "Setting custom PostgreSQL parameters..."
      stolonctl update --cluster-name=stolon-cluster --store-backend=etcdv3 --store-endpoints=http://etcd:2379 --patch '{"pgParameters":{"wal_level":"replica","archive_mode":"on","archive_command":"test ! -f $WAL_ARCHIVE_DIR/%f && cp %p $WAL_ARCHIVE_DIR/%f"}}'
      echo "Custom PostgreSQL parameters set."
    fi
    ;;
  "keeper")
    echo "Starting Stolon keeper..."
    stolon-keeper \
      --data-dir $PG_DATA_DIR \
      --cluster-name $STOLONCTL_CLUSTER_NAME \
      --store-backend $STOLONCTL_STORE_BACKEND \
      --store-endpoints $STOLONCTL_STORE_URL \
      --pg-listen-address $IP_ADDRESS \
      --pg-repl-username $PG_REPL_USERNAME \
      --pg-repl-password $PG_REPL_PASSWORD \
      --pg-su-username $PG_SU_USERNAME \
      --pg-su-password $PG_SU_PASSWORD \
      --uid $STKEEPER_UID \
      --pg-bin-path $PG_BIN_PATH \
      # --log-level debug \
      --pg-port $PG_PORT
    ;;
  "sentinel")
    echo "Starting Stolon sentinel..."
    stolon-sentinel \
      --cluster-name $STOLONCTL_CLUSTER_NAME \
      --store-backend $STOLONCTL_STORE_BACKEND \
      --store-endpoints $STOLONCTL_STORE_URL
    ;;
  "proxy")
    echo "Starting Stolon proxy..."
    stolon-proxy \
      --cluster-name $STOLONCTL_CLUSTER_NAME \
      --store-backend $STOLONCTL_STORE_BACKEND \
      --store-endpoints $STOLONCTL_STORE_URL \
      --listen-address 0.0.0.0
    ;;
  *)
    echo "Unknown role: $ROLE"
    exit 1
    ;;
esac

# Keep the script running
tail -f /dev/null