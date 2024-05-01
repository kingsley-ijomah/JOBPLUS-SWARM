#!/bin/bash

# Setup cron job

# Create a cron job that runs every minute
  echo "* * * * * pg_basebackup -h $PGHOST -p $PGPORT -U $PGUSER -D /backups -Fp -X stream -P > /var/log/pg_basebackup.log 2>&1" > /etc/cron.d/pg_basebackup

# Create a cron job that runs every day at 3:00 AM
# echo "0 3 * * * pg_basebackup -h $PGHOST -p $PGPORT -U $PGUSER -D /backups -Fp -X stream -P > /var/log/pg_basebackup.log 2>&1" > /etc/cron.d/pg_basebackup

# Give execution rights on the cron job
chmod 0644 /etc/cron.d/pg_basebackup

# Apply cron job
crontab /etc/cron.d/pg_basebackup

# Ensure permissions and ownership for the log file
touch /var/log/cron.log
chmod 0644 /var/log/cron.log  # Make sure it's readable and writable by the appropriate user
chown root:root /var/log/cron.log  # Change owner if necessary

# Ensure cron service is running
service cron start

# Output log content to the console (keeps the container running)
tail -f /var/log/cron.log