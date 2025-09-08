#!/bin/bash
# Script to install AWS CLI on Red Hat-based systems (RHEL, CentOS, Rocky, Alma)

# Download the AWS CLI installer ZIP file from official AWS URL
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# Install unzip package if not already installed (required to extract ZIP files)
sudo yum install unzip -y

# Extract the AWS CLI installer files from the ZIP
unzip awscliv2.zip

# Run the AWS CLI install script with superuser privileges
sudo ./aws/install

# Verify AWS CLI installation by printing its version
aws --version
