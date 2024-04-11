FROM quay.io/coreos/etcd:v3.3

# Set environment variables for etcd
ENV ETCD_ADVERTISE_CLIENT_URLS=http://etcd:2379
ENV ETCD_LISTEN_CLIENT_URLS=http://0.0.0.0:2379

# Expose the etcd client port
EXPOSE 2379

# Run etcd
CMD ["etcd"]
