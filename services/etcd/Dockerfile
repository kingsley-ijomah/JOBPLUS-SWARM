FROM quay.io/coreos/etcd:v3.3

# Create a non-root user and group for etcd to enhance security
# reuse GID and UID from etcd_setup ansible role
RUN groupadd -g 10002 etcdgroup && \
    useradd -r -g etcdgroup -u 10002 etcduser

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