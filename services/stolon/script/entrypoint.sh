#!/bin/bash

echo "Starting Stolon as a $ROLE..."

# Fetch the IP address of the container
IP_ADDRESS=$(hostname -I | awk '{print $1}')

# Initialize the database system and create users
if [ "$ROLE" = "keeper" ]; then
    echo "Initializing PostgreSQL data directory..."
    gosu postgres pg_ctl init -D "$PGDATA"
    gosu postgres pg_ctl -D "$PGDATA" -o "-c listen_addresses='*'" start

    # Wait until PostgreSQL is ready to accept connections
    echo "Waiting for PostgreSQL to start..."
    while ! pg_isready -q -h localhost -p 5432; do
        sleep 1
        echo "Waiting for PostgreSQL..."
    done

    echo "PostgreSQL is running. Creating users..."
    # Create the superuser
    gosu postgres psql -c "CREATE USER $PG_SU_USERNAME WITH SUPERUSER PASSWORD '$PG_SU_PASSWORD';"
    # Create the replication user
    gosu postgres psql -c "CREATE USER $PG_REPL_USERNAME REPLICATION LOGIN ENCRYPTED PASSWORD '$PG_REPL_PASSWORD';"
    # Create the application user
    gosu postgres psql -c "CREATE USER $PG_APP_USER WITH ENCRYPTED PASSWORD '$PG_APP_PASSWORD';"

    # Check if PG_APP_DB variable is provided and create the database
    if [ ! -z "$PG_APP_DB" ]; then
        echo "Creating application database $PG_APP_DB..."
        gosu postgres psql -c "CREATE DATABASE $PG_APP_DB;"

        echo "Granting all privileges on database $PG_APP_DB to user $PG_APP_USER..."
        gosu postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $PG_APP_DB TO $PG_APP_USER;"

        echo "Setting up privileges for user $PG_APP_USER on $PG_APP_DB..."
        # Ensure the user can create tables in the public schema
        gosu postgres psql -d $PG_APP_DB -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO $PG_APP_USER;"
        gosu postgres psql -d $PG_APP_DB -c "GRANT USAGE, CREATE ON SCHEMA public TO $PG_APP_USER;"
    else
        echo "No application database specified. Skipping database creation."
    fi
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
