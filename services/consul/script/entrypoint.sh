#!/bin/bash

# Detect the private IP address
IP_ADDRESS=$(hostname -I | awk '{print $1}')  

# Update the Consul configuration file
jq ".bind_addr = \"$IP_ADDRESS\" | .advertise_addr = \"$IP_ADDRESS\"" /consul/config/consul-config.json > /consul/config/temp.json && mv /consul/config/temp.json /consul/config/consul-config.json

# Start Consul with the updated configuration
exec consul agent -config-dir=/consul/config
