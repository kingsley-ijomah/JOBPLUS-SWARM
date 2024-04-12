# Use the official PostgreSQL image from the Docker Hub
FROM postgres:16.2

# Install Consul
ENV CONSUL_VERSION=1.18.1

ADD https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip /tmp/consul.zip

RUN apt-get update && apt-get install -y unzip && \
    unzip /tmp/consul.zip -d /usr/local/bin/ && \
    rm /tmp/consul.zip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy Consul configuration JSON
COPY config/consul-config.json /consul/config/consul-config.json

# Health check script
COPY script/check_postgres.sh /usr/local/bin/check_postgres.sh
RUN chmod +x /usr/local/bin/check_postgres.sh

# Expose ports for PostgreSQL and Consul
EXPOSE 5432 8500

# Consul will run as an agent in client mode
CMD ["consul", "agent", "-config-dir=/consul/config"]