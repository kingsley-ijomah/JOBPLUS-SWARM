# Use the official PostgreSQL image as a base
FROM postgres:16.2

# Install cron and other necessary tools
RUN apt-get update && \
    apt-get install -y cron && \
    rm -rf /var/lib/apt/lists/*

# Copy the entrypoint script to the container
COPY script/entrypoint.sh /entrypoint.sh

RUN mkdir -p /var/lib/postgresql/backups  && \
    chown -R postgres:postgres /var/lib/postgresql/backups

# Make the entrypoint script executable
RUN chmod +x /entrypoint.sh

# Run the entrypoint script
ENTRYPOINT ["/entrypoint.sh"]
