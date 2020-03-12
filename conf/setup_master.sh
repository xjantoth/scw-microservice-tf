#!/bin/bash

set -ex

COMMON=/opt/common.sh

# Exporting all the functions from common.sh file
while [ ! -f ${COMMON} ]
do
  echo -e "File ${COMMON} not present 
  at machine yet ...\nGoing to sleep for 2[s]"
  sleep 2
done

echo -e "File ${COMMON} present!"
source ${COMMON}
#yum update -y

# Disable welcome
disable_welome

# Disable Selinux
disable_selinux

# Disable SWAP
swapp_off

# Setup firewall rules to allow: Master/Worker communication within cluster
setup_pkg firewalld 

for couple in 6443:tcp 2379-2380:tcp 10250:tcp 10251:tcp 10252:tcp 6783:tcp 6783:udp 6784:udp; do
  PORT=$(echo ${couple} | awk -F":" '{print $1}')
  PROTOCOL=$(echo ${couple} | awk -F":" '{print $2}')
  allow_fw_port ${PORT} ${PROTOCOL}
done

firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 0 -j ACCEPT
# firewall-cmd --permanent --add-port=10255/tcp
# firewall-cmd --add-masquerade --permanent
firewall-cmd --reload
firewall-cmd --zone=public --list-all

# Setup bridge interface
setup_bridge

# Install docker
setup_pkg docker

# Install kubelet kubeadm kubectl packages create kubernetes yum repository
add_yum_repo 
yum install -y kubeadm kubectl --disableexcludes=kubernetes
setup_pkg kubelet

# Start/Initiate Kubernetes Master
kubeadm init --service-cidr=192.168.1.0/24

# Copy admin.conf to a proper location to be able to use kubectl
create_dir "$HOME/.kube"
yes | cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

# Download file: weave_custom.yaml 
curl \
-L \
-o weave_custom.yaml \
"https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')&env.IPALLOC_RANGE=192.168.0.0/24"
# Execute previously downloaded file: file
sed -i.bak 's/apiVersion: extensions\/v1beta1/apiVersion: apps\/v1/g' /root/weave_custom.yaml
sed -i.bak '/^\s*kind:\s*DaemonSet/,/^\s*template/s/^\(\s*spec:\s*\)/\1 \n      selector:\n        matchLabels:\n          name: weave-net/'  /root/weave_custom.yaml
kubectl create -f weave_custom.yaml

# Install helm binary
# install_helm

install_helm3

# Setting up helm-tiller communication
# secure_helm_tiller

# Execute show-join-to-k8s-command.sh script to retrive join to k8s command
# kubeadm token create --print-join-command

echo -e "Please reboot server ..."

