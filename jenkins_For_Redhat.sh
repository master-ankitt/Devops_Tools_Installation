#!/bin/bash
# Jenkins installation on Red Hat-based systems (RHEL, CentOS, Rocky, Alma)

# Update system packages
sudo yum update -y

# Install Java (OpenJDK 17)
sudo yum install java-17-openjdk -y

# Add the Jenkins repository and import the GPG key
sudo wget -O /etc/yum.repos.d/jenkins.repo \
  https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Install Jenkins
sudo yum install jenkins -y

# Enable and start the Jenkins service
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Optionally, check Jenkins status
# sudo systemctl status jenkins
