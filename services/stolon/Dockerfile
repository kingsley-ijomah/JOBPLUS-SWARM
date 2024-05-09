# Use the official PostgreSQL image as a base with the version from the argument
ARG PG_VERSION=16.2

FROM postgres:${PG_VERSION}

# Define the PostgreSQL folder
ARG PG_FOLDER=16

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
    mv /stolon-installation/*/bin/* /usr/local/bin/ && \
    rm -rf /stolon-installation stolon.tar.gz

# Clean up installation files
RUN apt-get purge -y --auto-remove unzip

# Add a user for Stolon with a specific UID/GID, and set permissions
# user and UID used by pg_basebackup
RUN groupadd -g 9999 stolon && \
    useradd -r -u 9999 -g stolon -m -s /bin/bash stolon && \
    mkdir -p /var/lib/postgresql/data /var/lib/postgresql/wal_archive /var/log/postgresql && \
    chown -R stolon:stolon /var/lib/postgresql/wal_archive /var/lib/postgresql/data /var/log/postgresql

# Set up environment variables
ENV STOLONCTL_CLUSTER_NAME=stolon-cluster \
    STOLONCTL_STORE_BACKEND=etcdv3 \
    STOLONCTL_STORE_URL=http://etcd:2379 \
    PG_DATA_DIR=/var/lib/postgresql/data \
    PG_BIN_PATH=/usr/lib/postgresql/${PG_FOLDER}/bin \
    PG_PORT=5432 \
    WAL_ARCHIVE_DIR=/var/lib/postgresql/wal_archive


# Expose PostgreSQL and Stolon proxy ports
EXPOSE 5432 5433

# Copy the entrypoint script into the container
COPY script/entrypoint.sh /entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /entrypoint.sh

# Set the entrypoint script as the entrypoint for the container
ENTRYPOINT ["/entrypoint.sh"]

# Switch to the stolon user
USER stolon