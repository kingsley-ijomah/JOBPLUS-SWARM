FROM postgres:16.2

# Install Python virtual environment
RUN apt-get update && apt-get install -y python3-venv

# Create a virtual environment
RUN python3 -m venv /opt/venv

# Install Patroni
RUN . /opt/venv/bin/activate && \
    pip install patroni[etcd] psycopg2-binary

# Switch to non-root user
USER postgres

# Copy the configuration file
COPY config/patroni.yml /etc/patroni/patroni.yml

# Set the environment variables
ENV PATRONI_SCOPE=postgres
ENV PATRONI_RESTAPI_CONNECT_ADDRESS=patroni:8008
ENV PATRONI_RESTAPI_LISTEN=0.0.0.0:8008
ENV PATRONI_ETCD_URL=http://etcd:2379
ENV PATRONI_POSTGRESQL_CONNECT_ADDRESS=localhost:5432
ENV PATRONI_POSTGRESQL_DATA_DIR=/var/lib/postgresql/data
ENV PATRONI_POSTGRESQL_LISTEN=0.0.0.0:5432
ENV PATRONI_POSTGRESQL_BIN_DIR=/usr/lib/postgresql/16/bin
ENV PATRONI_POSTGRESQL_PG_REWIND="true"

# Activate the virtual environment and run Patroni
ENTRYPOINT ["/bin/bash", "-c", "source /opt/venv/bin/activate && exec patroni /etc/patroni/patroni.yml"]