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

      # Automatically set PostgreSQL parameters after initialization
      # Set up the Stolon parameters
      # wal_level: replica - Archive all WAL files
      # archive_mode: on - Enable WAL archiving
      # archive_command: test ! -f ${STKEEPER_DATA_DIR}/%f - Check WAL file existence in the STKEEPER_DATA_DIR 
      # && cp %p ${STKEEPER_DATA_DIR}/%f - Copy WAL files to the STKEEPER_DATA_DIR
      echo "Setting custom PostgreSQL parameters..."
      stolonctl update --patch "{
        \"pgParameters\": {
          \"wal_level\": \"replica\",
          \"archive_mode\": \"off\",
          \"archive_command\": \"test ! -f /${STKEEPER_DATA_DIR}/%f && cp %p /${STKEEPER_DATA_DIR}/%f\"
        }
      }"
      echo "Custom PostgreSQL parameters set."

      # Reload PostgreSQL configuration
      echo "Reloading PostgreSQL configuration..."
      psql -h localhost -U postgres -c "SELECT pg_reload_conf();"
      echo "PostgreSQL configuration reloaded."
    fi
    ;;
  "keeper")
    echo "Starting Stolon keeper..."
    stolon-keeper \
      --data-dir $STKEEPER_DATA_DIR \
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