#!/bin/sh

set -ex

curl https://download.opensuse.org/repositories/isv:/kubernetes:/addons:/cri-o:/stable:/v1.33:/build/rpm/isv:kubernetes:addons:cri-o:stable:v1.33:build.repo | sudo tee /etc/yum.repos.d/kubernetes-addons.repo
curl https://download.opensuse.org/repositories/isv:/kubernetes:/core:/stable:/v1.33/rpm/isv:kubernetes:core:stable:v1.33.repo                               | sudo tee /etc/yum.repos.d/kubernetes-core.repo

echo overlay      | sudo tee    /etc/modules-load.d/kubernetes.conf
echo br_netfilter | sudo tee -a /etc/modules-load.d/kubernetes.conf
sudo modprobe overlay
sudo modprobe br_netfilter

echo net.ipv4.ip_forward                 = 1 | sudo tee    /etc/sysctl.d/kubernetes.conf
echo net.bridge.bridge-nf-call-iptables  = 1 | sudo tee -a /etc/sysctl.d/kubernetes.conf
echo net.bridge.bridge-nf-call-ip6tables = 1 | sudo tee -a /etc/sysctl.d/kubernetes.conf
sudo sysctl --system

sudo dnf install cri-o kubelet kubeadm kubectl
sudo systemctl enable --now crio
sudo systemctl enable --now kubelet

sudo kubeadm config images pull

sudo kubeadm reset --cleanup-tmp-dir
sudo kubeadm init --pod-network-cidr 10.244.0.0/16
sudo kubeadm init --config 01-INSTALL-NoSwap.yaml
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
kubectl get cm -n kube-system kubeadm-config -o yaml | grep Subnet

sudo firewall-cmd --permanent --zone=public --add-service=http --add-service=https
sudo firewall-cmd             --zone=public --add-service=http --add-service=https
sudo firewall-cmd --zone=public --list-all

sudo firewall-cmd --permanent --zone=trusted --add-source=10.244.0.0/16
sudo firewall-cmd --permanent --zone=trusted --add-source=10.96.0.0/12
sudo firewall-cmd             --zone=trusted --add-source=10.244.0.0/16
sudo firewall-cmd             --zone=trusted --add-source=10.96.0.0/12
sudo firewall-cmd --zone=trusted --list-all

kubectl taint nodes $(hostname --long) node-role.kubernetes.io/control-plane:NoSchedule-

# eof
