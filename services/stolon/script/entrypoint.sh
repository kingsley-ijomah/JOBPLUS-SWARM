#!/bin/bash

echo "Starting Stolon as a $ROLE..."

# Wait for Consul to become ready
echo "Waiting for Consul to be ready at $STOLONCTL_STORE_BACKEND:$CONSUL_PORT..."
while ! curl -s http://$STOLONCTL_STORE_BACKEND:$CONSUL_PORT/v1/status/leader | grep -q '"'; do
    echo "Waiting for Consul to start..."
    sleep 1
done
echo "Consul is ready."

# Fetch the IP address of the container
IP_ADDRESS=$(hostname -I | awk '{print $1}')

if [ "$ROLE" = "sentinel" ]; then
    # Verify registration with Consul
    while ! curl -s "http://$STOLONCTL_STORE_BACKEND:$CONSUL_PORT/v1/kv/stolon/cluster/$STOLONCTL_CLUSTER_NAME/keepers/info?keys" | grep -q "$KEEPER_ID"; do
        echo "Keeper not registered in Consul, waiting..."
        sleep 1
    done
    echo "Keeper is registered in Consul."
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
      --pg-su-password $PG_SU_PASSWORD \
      --uid $STKEEPER_UID \
      --pg-bin-path $PG_BIN_PATH \
      --pg-port $PG_PORT
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
      --store-endpoints $STOLONCTL_STORE_URL \
      --listen-address 0.0.0.0
    ;;
  *)
    echo "Unknown role: $ROLE"
    exit 1
    ;;
esac
