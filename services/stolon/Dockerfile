# Use the official PostgreSQL image as a base
FROM postgres:15

# Define the version of Stolon being used
ENV STOLON_VERSION v0.17.0

# Install necessary packages
RUN apt-get update && \
    apt-get install -y curl unzip procps && \
    rm -rf /var/lib/apt/lists/* 

# Download and extract Stolon
RUN curl -L https://github.com/sorintlab/stolon/releases/download/${STOLON_VERSION}/stolon-${STOLON_VERSION}-linux-amd64.tar.gz -o stolon.tar.gz && \
    mkdir -p /stolon-installation && \
    tar -xzf stolon.tar.gz -C /stolon-installation && \
    ls /stolon-installation && \
    mv /stolon-installation/*/bin/* /usr/local/bin/

# Clean up installation files
RUN rm -rf /stolon-installation stolon.tar.gz && \
    apt-get purge -y --auto-remove unzip

# Verify binaries are in the expected location
RUN ls /usr/local/bin/stolon*

# Set up environment variables
ENV STOLONCTL_CLUSTER_NAME=stolon-cluster \
    STOLONCTL_STORE_BACKEND=etcdv3 \
    STOLONCTL_STORE_URL=http://etcd:2379 \
    # CONSUL_PORT=8500 \
    STKEEPER_DATA_DIR=/stolon/data \
    PG_DATA_DIR=/var/lib/postgresql/data \
    PG_BIN_PATH=/usr/lib/postgresql/16/bin \
    PG_PORT=5432

# Expose PostgreSQL and Stolon proxy ports
EXPOSE 5432 5433

# Copy the entrypoint script into the container
COPY script/entrypoint.sh /entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /entrypoint.sh

# Set the entrypoint script as the entrypoint for the container
ENTRYPOINT ["/entrypoint.sh"]