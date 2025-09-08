#!/bin/bash

# Detect if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

# Step 1: Disable SELinux
echo "Disabling SELinux..."
setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
echo "SELinux has been disabled."

# Step 2: Disable Swap
echo "Disabling swap..."
swapoff -a
sed -i '/swap/d' /etc/fstab
echo "Swap has been disabled."

# Step 3: Enable IP forwarding for Kubernetes networking
echo "Enabling IP forwarding..."
tee /etc/sysctl.d/k8s.conf <<EOF
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
sysctl --system
echo "IP forwarding has been enabled."

# Step 4: Load necessary kernel modules
echo "Loading necessary kernel modules..."
modprobe br_netfilter
tee /etc/modules-load.d/k8s.conf <<EOF
br_netfilter
EOF

# Step 5: Stop and disable firewall
echo "Stopping and disabling firewall..."
systemctl stop firewalld
systemctl disable firewalld
echo "Firewall has been disabled."

# Step 6: Update /etc/hosts file
echo "Updating /etc/hosts file..."
cat <<EOF >> /etc/hosts
192.168.29.171    master master.example.com
192.168.29.172    node1  node1.example.com
EOF
echo "/etc/hosts file has been updated."

# Step 7: Set hostname
echo "Setting hostname to master.example.com..."
hostnamectl set-hostname master.example.com
echo "Hostname has been set to master.example.com."

# Step 8: Install Docker
echo "Installing Docker..."
yum remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine buildah
yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce docker-ce-cli containerd.io

# Step 9: Configure containerd for SystemdCgroup
echo "Configuring containerd to use SystemdCgroup..."
containerd config default | tee /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
systemctl restart containerd

# Step 10: Start and enable Docker
echo "Starting and enabling Docker..."
systemctl start docker
systemctl enable docker

# Step 11: Install Kubernetes (kubeadm, kubelet, kubectl)
echo "Adding Kubernetes repository..."
cat <<EOF | tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.31/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.31/rpm/repodata/repomd.xml.key
EOF

echo "Installing Kubernetes components..."
yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

# Step 12: Enable and start kubelet
echo "Enabling and starting kubelet..."
systemctl enable kubelet
systemctl start kubelet

# Step 13: Initialize Kubernetes Master Node
echo "Initializing Kubernetes Master Node..."
kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=$(hostname -I | awk '{print $1}')

# Step 14: Configure kubectl for the root user
echo "Configuring kubectl for the root user..."
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# Step 15: Install Calico as the CNI plugin
echo "Installing Calico networking..."
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml
echo "Calico networking has been installed."

echo "Master node installation completed!"
echo "You can now deploy workloads and manage your Kubernetes cluster."
