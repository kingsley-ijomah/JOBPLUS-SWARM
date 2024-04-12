FROM ubuntu:20.04

# Install etcd
RUN apt-get update && apt-get install -y wget && \
    wget https://github.com/etcd-io/etcd/releases/download/v3.3.25/etcd-v3.3.25-linux-amd64.tar.gz && \
    tar -xvf etcd-v3.3.25-linux-amd64.tar.gz && \
    mv etcd-v3.3.25-linux-amd64/etcd* /usr/local/bin/ && \
    rm -rf etcd-v3.3.25-linux-amd64* && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a non-root user and group for etcd to enhance security
RUN groupadd -g 10002 etcdgroup && \
    useradd -m -u 10002 -g etcdgroup -s /bin/bash etcduser

# Create directory for etcd data and set permissions
RUN mkdir /etcd-data && \
    chown etcduser:etcdgroup /etcd-data && \
    chmod 700 /etcd-data

# Set environment variables for etcd
ENV ETCD_ADVERTISE_CLIENT_URLS=http://etcd:2379 \
    ETCD_LISTEN_CLIENT_URLS=http://0.0.0.0:2379 \
    ETCD_DATA_DIR=/etcd-data \
    ETCDCTL_API=3

# Expose the etcd client port
EXPOSE 2379

# Switch to non-root user before running etcd
USER etcduser

# Run etcd
CMD ["etcd"]