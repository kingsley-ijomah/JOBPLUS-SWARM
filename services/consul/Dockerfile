# Use the official PostgreSQL image from the Docker Hub
FROM postgres:16.2

# Install Consul and jq for JSON processing
ENV CONSUL_VERSION=1.18.1

ADD https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip /tmp/consul.zip
RUN apt-get update && apt-get install -y unzip jq && \
    unzip /tmp/consul.zip -d /usr/local/bin/ && \
    rm /tmp/consul.zip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create a non-root user and group for consul to enhance security
# with specified UID and GID defined in consul setup ansible role
RUN groupadd -g 10003 consulgroup && \
    useradd -m -u 10003 -g consulgroup -s /bin/bash consuluser

# Create directory for consul data and set permissions
RUN mkdir /consul-data && \
    chown consuluser:consulgroup /consul-data && \
    chmod 700 /consul-data

# Copy Consul configuration JSON
COPY config/consul-config.json /consul/config/consul-config.json

# Health check script
COPY script/check_postgres.sh /usr/local/bin/check_postgres.sh
RUN chmod +x /usr/local/bin/check_postgres.sh

# Entry point script
COPY script/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose ports for PostgreSQL and Consul
EXPOSE 5432 8500

# Set the startup script as the entry point
ENTRYPOINT ["/entrypoint.sh"]