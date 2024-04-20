# Start from a specific version of the official Consul image from HashiCorp's namespace
FROM hashicorp/consul:1.18.1

# Install jq
RUN apk add --no-cache jq

# Set environment variables for network interfaces
ENV CONSUL_BIND_INTERFACE=eth0
ENV CONSUL_CLIENT_INTERFACE=eth0

# Copy Consul configuration JSON
COPY config/consul-config.json /consul/config/consul-config.json

# Entry point script
COPY script/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose ports for Consul
EXPOSE 8500

ENTRYPOINT ["/entrypoint.sh"]