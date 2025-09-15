#!/bin/bash
# Script to install Node.js 18.x and npm on Ubuntu/Debian or RedHat/CentOS

set -e
echo "Detecting OS..."

# Detect package manager
if command -v apt >/dev/null 2>&1; then
    OS="debian"
elif command -v yum >/dev/null 2>&1; then
    OS="redhat"
elif command -v dnf >/dev/null 2>&1; then
    OS="redhat"
else
    echo "Unsupported OS. Only Debian/Ubuntu or RedHat/CentOS supported."
    exit 1
fi

echo " Detected OS family: $OS"

if [ "$OS" = "debian" ]; then
    echo "Updating system..."
    sudo apt update && sudo apt upgrade -y

    echo "Installing Node.js 18.x..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt install -y nodejs

elif [ "$OS" = "redhat" ]; then
    echo "Updating system..."
    if command -v dnf >/dev/null 2>&1; then
        sudo dnf -y update
    else
        sudo yum -y update
    fi

    echo "Installing Node.js 18.x..."
    curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
    if command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y nodejs
    else
        sudo yum install -y nodejs
    fi
fi

echo "Installation complete!"
echo "Checking versions..."

node -v
npm -v

