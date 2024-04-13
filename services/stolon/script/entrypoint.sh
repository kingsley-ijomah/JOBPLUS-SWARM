#!/bin/bash

echo "Starting Stolon as a $ROLE..."

# Fetch the IP address of the container
IP_ADDRESS=$(hostname -I | awk '{print $1}')

# Initialize the database system and create users
if [ "$ROLE" = "keeper" ] && [ ! -d "$STKEEPER_DATA_DIR" ]; then
    gosu postgres pg_ctl init
    gosu postgres pg_ctl -D "$STKEEPER_DATA_DIR" -o "-c listen_addresses='localhost'" start
    gosu postgres psql -c "CREATE USER $PG_SU_USERNAME WITH SUPERUSER PASSWORD '$PG_SU_PASSWORD';"
    gosu postgres psql -c "CREATE USER $PG_REPL_USERNAME REPLICATION LOGIN ENCRYPTED PASSWORD '$PG_REPL_PASSWORD';"
    gosu postgres pg_ctl -D "$STKEEPER_DATA_DIR" stop
fi

case "$ROLE" in
  "keeper")
    exec stolon-keeper \
      --data-dir $STKEEPER_DATA_DIR \
      --cluster-name $STOLONCTL_CLUSTER_NAME \
      --store-backend $STOLONCTL_STORE_BACKEND \
      --store-endpoints $STOLONCTL_STORE_URL \
      --pg-listen-address $IP_ADDRESS \
      --pg-repl-username $PG_REPL_USERNAME \
      --pg-repl-password $PG_REPL_PASSWORD \
      --pg-su-username $PG_SU_USERNAME \
      --pg-su-password $PG_SU_PASSWORD
    ;;
  "sentinel")
    exec stolon-sentinel \
      --cluster-name $STOLONCTL_CLUSTER_NAME \
      --store-backend $STOLONCTL_STORE_BACKEND \
      --store-endpoints $STOLONCTL_STORE_URL
    ;;
  "proxy")
    exec stolon-proxy \
      --cluster-name $STOLONCTL_CLUSTER_NAME \
      --store-backend $STOLONCTL_STORE_BACKEND \
      --store-endpoints $STOLONCTL_STORE_URL
    ;;
  *)
    echo "Unknown role: $ROLE"
    exit 1
    ;;
esac
