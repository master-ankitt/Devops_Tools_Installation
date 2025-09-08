#!/bin/bash
# Ansible installation on Ubuntu/Debian-based systems

# Update package list
sudo apt update -y

# Install required dependencies
sudo apt install -y software-properties-common

# Add the official Ansible PPA
sudo add-apt-repository --yes --update ppa:ansible/ansible

# Install Ansible
sudo apt install -y ansible

# Verify Ansible installation
ansible --version
