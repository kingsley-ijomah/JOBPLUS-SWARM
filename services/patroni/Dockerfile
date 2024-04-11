FROM postgres::16.2

# Install Patroni
RUN apt-get update && apt-get install -y python3-pip && \
    pip3 install patroni[etcd]

# Copy the configuration file
COPY patroni.yml /etc/patroni/patroni.yml

# Set the environment variables
ENV PATRONI_SCOPE=postgres
ENV PATRONI_RESTAPI_CONNECT_ADDRESS=patroni:8008
ENV PATRONI_RESTAPI_LISTEN=0.0.0.0:8008
ENV PATRONI_ETCD_URL=http://etcd:2379
ENV PATRONI_POSTGRESQL_CONNECT_ADDRESS=localhost:5432
ENV PATRONI_POSTGRESQL_DATA_DIR=/var/lib/postgresql/data
ENV PATRONI_POSTGRESQL_LISTEN=0.0.0.0:5432
ENV PATRONI_POSTGRESQL_BIN_DIR=/usr/lib/postgresql/12/bin
ENV PATRONI_POSTGRESQL_PG_REWIND="true"

# Set the entrypoint to run Patroni
ENTRYPOINT ["patroni", "/etc/patroni/patroni.yml"]
