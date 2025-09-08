#!/bin/bash
# Ansible installation on Red Hat-based systems (RHEL, CentOS, Rocky, Alma)

# Update system packages
sudo yum update -y

# Check if EPEL repo is already available
if ! yum repolist | grep -q epel; then
  echo "EPEL repository not found. Adding manually..."

  # Get the RHEL major version (e.g., 7, 8, 9)
  OS_VERSION=$(rpm -E %{rhel})

  # Download and install the correct EPEL release
  case $OS_VERSION in
    7)
      sudo wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
      sudo yum install -y epel-release-latest-7.noarch.rpm
      ;;
    8)
      sudo wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
      sudo yum install -y epel-release-latest-8.noarch.rpm
      ;;
    9)
      sudo wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
      sudo yum install -y epel-release-latest-9.noarch.rpm
      ;;
    *)
      echo "Unsupported or unknown RHEL version: $OS_VERSION"
      exit 1
      ;;
  esac
fi

# Install Ansible
sudo yum install -y ansible

# Verify Ansible installation
ansible --version
