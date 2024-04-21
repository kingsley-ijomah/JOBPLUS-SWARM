# Use the official PostgreSQL image as a base
FROM postgres:16.2

# Define the version of Stolon being used
ENV STOLON_VERSION v0.17.0

# Install necessary packages
RUN apt-get update && \
    apt-get install -y curl unzip && \
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
RUN ls /usr/local/bin/stolon-*

# Set up the environment variables
ENV STOLONCTL_CLUSTER_NAME stolon-cluster
ENV STOLONCTL_STORE_BACKEND consul
ENV STOLONCTL_STORE_URL http://consul:8500

# Expose PostgreSQL and Stolon proxy ports
EXPOSE 5432 5433

# Copy the entrypoint script into the container
COPY script/entrypoint.sh /entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /entrypoint.sh

# Set the entrypoint script as the entrypoint for the container
# ENTRYPOINT ["/entrypoint.sh"]

# Command to keep the container running
# temp delete
CMD ["tail", "-f", "/dev/null"] 
```