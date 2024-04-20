#!/bin/sh

# Detect the private IP address using ip command
IP_ADDRESS=$(ip addr show eth0 | awk '$1 == "inet" {gsub(/\/.*$/, "", $2); print $2}')

# Update the Consul configuration file
jq ".bind_addr = \"$IP_ADDRESS\" | .advertise_addr = \"$IP_ADDRESS\"" /consul/config/consul-config.json > /consul/config/temp.json && mv /consul/config/temp.json /consul/config/consul-config.json

# Start Consul with the updated configuration
exec consul agent -config-dir=/consul/config
