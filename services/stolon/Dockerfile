# Use the official PostgreSQL image as a base
FROM postgres:16.2

# Define the version of Stolon being used
ENV STOLON_VERSION v0.17.0

# Install necessary packages
RUN apt-get update && \
    apt-get install -y curl unzip && \
    rm -rf /var/lib/apt/lists/*

# Install Stolon
RUN curl -L https://github.com/sorintlab/stolon/releases/download/${STOLON_VERSION}/stolon-${STOLON_VERSION}-linux-amd64.tar.gz | tar -xz -C /usr/local/bin --strip-components=1

# Verify binary installation and add to PATH if necessary
RUN ls /usr/local/bin/stolon-* && \
    ln -s /usr/local/bin/stolon-keeper /usr/local/bin/stolon-keeper && \
    ln -s /usr/local/bin/stolon-sentinel /usr/local/bin/stolon-sentinel && \
    ln -s /usr/local/bin/stolon-proxy /usr/local/bin/stolon-proxy

# Clean up unnecessary files
RUN apt-get purge -y --auto-remove curl unzip

# Set up the environment variables
ENV STOLONCTL_CLUSTER_NAME stolon-cluster
ENV STOLONCTL_STORE_BACKEND etcd
ENV STOLONCTL_STORE_URL etcd://etcd:2379

# Expose PostgreSQL and Stolon proxy ports
EXPOSE 5432 5433

# Copy the entrypoint script into the container
COPY script/entrypoint.sh /entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /entrypoint.sh

# Set the entrypoint script as the entrypoint for the container
ENTRYPOINT ["/entrypoint.sh"]
