#!/bin/bash

# Detect if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

# Step 1: Disable SELinux
echo "Disabling SELinux..."
setenforce 0
sudo sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
echo "SELinux has been disabled."

# Step 2: Disable Swap
echo "Disabling swap..."
swapoff -a
sudo sed -i '/swap/d' /etc/fstab
echo "Swap has been disabled."

# Step 3: Enable IP forwarding for Kubernetes networking
echo "Enabling IP forwarding..."
sudo tee /etc/sysctl.d/k8s.conf <<EOF
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
sudo sysctl --system
echo "IP forwarding has been enabled."

# Step 4: Load necessary kernel modules
echo "Loading necessary kernel modules..."
modprobe br_netfilter
sudo tee /etc/modules-load.d/k8s.conf <<EOF
br_netfilter
EOF

# Step 5: Install Docker
echo "Installing Docker..."
yum remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine buildah
yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce docker-ce-cli containerd.io

# Step 6: Configure containerd for SystemdCgroup
echo "Configuring containerd to use SystemdCgroup..."
containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
sudo systemctl restart containerd

# Step 7: Start and enable Docker
echo "Starting and enabling Docker..."
sudo systemctl start docker
sudo systemctl enable docker

# Step 8: Install Kubernetes (kubeadm, kubelet, kubectl)
echo "Adding Kubernetes repository..."
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.31/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.31/rpm/repodata/repomd.xml.key
EOF

echo "Installing Kubernetes components..."
yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

# Step 9: Enable and start kubelet
echo "Enabling and starting kubelet..."
sudo systemctl enable kubelet
sudo systemctl start kubelet

# Step 10: Join worker node to the Kubernetes cluster
if [[ -z "$1" ]]; then
    echo "Please provide the kubeadm join token and discovery token CA cert hash."
    echo "Usage: sudo ./install_kubernetes_worker.sh <join-command>"
    exit 1
else
    echo "Running the provided join command..."
    eval "$1"
fi

echo "Worker node has successfully joined the Kubernetes cluster!"

