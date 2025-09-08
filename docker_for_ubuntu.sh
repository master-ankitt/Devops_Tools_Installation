#!/bin/bash
# Docker installation on Ubuntu/Debian-based systems

# Update package list
sudo apt-get update -y

# Install required dependencies to use a repository over HTTPS
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker’s official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  gpg --dearmor | \
  sudo tee /etc/apt/keyrings/docker.gpg > /dev/null

# Add Docker's official repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package list again with Docker repo
sudo apt-get update -y

# Install Docker Engine (Community Edition)
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verify Docker installation
docker --version

# Start Docker service
sudo systemctl start docker

# Enable Docker to start on boot
sudo systemctl enable docker
