# Start from a specific version of the official Consul image
FROM consul:1.18

# Set environment variables for network interfaces
ENV CONSUL_BIND_INTERFACE=eth0
ENV CONSUL_CLIENT_INTERFACE=eth0

# Create a non-root user and group for Consul to enhance security
# with specified UID and GID defined in consul setup ansible role
RUN groupadd -g 10003 consulgroup && \
    useradd -m -u 10003 -g consulgroup -s /bin/bash consuluser

# Copy Consul configuration JSON
COPY config/consul-config.json /consul/config/consul-config.json

# Ensure the non-root user has the necessary permissions
RUN chown -R consuluser:consulgroup /consul/data /consul/config

# Entry point script
COPY script/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && chown consuluser:consulgroup /entrypoint.sh

# Expose ports for Consul
EXPOSE 8500

# Switch to the non-root user
USER consuluser

ENTRYPOINT ["/entrypoint.sh"]