#!/bin/bash
# Jenkins installation on Ubuntu

# Update the list of available packages and their versions
sudo apt update -y

# Install necessary dependencies: fontconfig and OpenJDK 17
# Jenkins requires Java to run, and OpenJDK 17 is a compatible version
sudo apt install fontconfig openjdk-17-jre -y

# Download and add the Jenkins GPG key to your system's keyring for package verification
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

# Add the Jenkins package repository to your system's sources list
# This tells apt where to find the Jenkins installation files
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update the package list again to include Jenkins from the newly added repository
sudo apt-get update -y

# Install Jenkins
sudo apt-get install jenkins -y

# Enable Jenkins service to start on boot
sudo systemctl enable jenkins

# Start the Jenkins service immediately
sudo systemctl start jenkins

# (Optional) To check if Jenkins is running, you can use:
# sudo systemctl status jenkins
