FROM postgres::16.2

# Install Patroni
RUN apt-get update && apt-get install -y python3-pip && \
    pip3 install patroni[etcd]

# Copy the configuration file
COPY patroni.yml /etc/patroni/patroni.yml

# Set the entrypoint to run Patroni
ENTRYPOINT ["patroni", "/etc/patroni/patroni.yml"]
