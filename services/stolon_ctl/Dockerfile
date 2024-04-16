# Use an official base image
FROM debian:buster

# Set environment variables for version and installation directory
ENV STOLON_VERSION=v0.16.0
ENV INSTALL_PATH=/usr/local/bin

# Install dependencies
RUN apt-get update && \
    apt-get install -y wget ca-certificates curl netcat && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Download and install stolonctl
RUN wget https://github.com/sorintlab/stolon/releases/download/${STOLON_VERSION}/stolon-${STOLON_VERSION}-linux-amd64.tar.gz -O /tmp/stolon.tar.gz && \
    tar -xzf /tmp/stolon.tar.gz -C /tmp && \
    mv /tmp/stolon-${STOLON_VERSION}-linux-amd64/bin/stolonctl ${INSTALL_PATH}/stolonctl && \
    rm -rf /tmp/stolon*

# Set the path
ENV PATH=$PATH:${INSTALL_PATH}

# Set the working directory
WORKDIR /root

# Copy the entrypoint script
COPY script/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Command to keep the container running
CMD ["tail", "-f", "/dev/null"]
