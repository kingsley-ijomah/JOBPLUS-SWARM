# Use the official PostgreSQL image as a base
FROM postgres:16.2

# Install cron and other necessary tools
RUN apt-get update && \
    apt-get install -y cron && \
    rm -rf /var/lib/apt/lists/*

# Copy the entrypoint script to the container
COPY script/entrypoint.sh /entrypoint.sh

# Add a user for Stolon with a specific UID/GID, and set permissions
# user and UID used by stolon service image
RUN groupadd -g 9999 stolon && \
    useradd -r -u 9999 -g stolon -m -s /bin/bash stolon && \
    mkdir -p /var/lib/postgresql/backups  && \
    chown -R stolon:stolon /var/lib/postgresql/backups

# Make the entrypoint script executable
RUN chmod +x /entrypoint.sh

# Run the entrypoint script
ENTRYPOINT ["/entrypoint.sh"]

# Switch to the stolon user
USER stolon
