#!/bin/bash
# Grafana installation on Red Hat-based systems (RHEL, CentOS, Rocky, Alma)

# Install required packages for repository management
sudo yum install -y wget

# Add Grafana's official YUM repository
sudo tee /etc/yum.repos.d/grafana.repo > /dev/null <<EOF
[grafana]
name=Grafana OSS
baseurl=https://rpm.grafana.com
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://rpm.grafana.com/gpg.key
EOF

# Import Grafana's GPG key for package verification
sudo rpm --import https://rpm.grafana.com/gpg.key

# Install Grafana OSS (Open Source Edition)
sudo yum install grafana -y

# Start Grafana service
sudo systemctl start grafana-server

# Enable Grafana to start on boot
sudo systemctl enable grafana-server

# After installation, access Grafana at:
# http://your-server-ip:3000
# Default login: admin / admin
