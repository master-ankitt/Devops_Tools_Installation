#!/bin/bash
# Grafana installation on Ubuntu/Debian-based systems

# Install required packages for apt to use HTTPS
sudo apt-get install -y apt-transport-https software-properties-common wget

# Create directory to store Grafana's GPG key
sudo mkdir -p /etc/apt/keyrings/

# Download and add Grafana's GPG key
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | \
sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null

# Add Grafana's official repository to APT sources list
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | \
sudo tee /etc/apt/sources.list.d/grafana.list > /dev/null

# Update package list to include Grafana's repository
sudo apt-get update -y

# Install Grafana OSS (Open Source Edition)
sudo apt-get install grafana -y

# Start Grafana service
sudo systemctl start grafana-server

# Enable Grafana to start automatically at system boot
sudo systemctl enable grafana-server

# After installation, access Grafana at:
# http://your-server-ip:3000
# Default login: admin / admin
