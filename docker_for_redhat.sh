#!/bin/bash
# Docker installation on RHEL/CentOS/Rocky/AlmaLinux

# Install required packages
sudo yum install -y yum-utils

# Add Docker repository
sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo

# Install Docker Engine (using --nobest to resolve potential version conflicts)
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin --nobest --allowerasing -y

# Verify Docker installation
docker --version

# Start Docker service
sudo systemctl start docker

# Enable Docker to start on boot
sudo systemctl enable docker
