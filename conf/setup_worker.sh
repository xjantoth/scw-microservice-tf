#!/bin/bash

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

# Disable Selinux
disable_selinux

# Disable SWAP
swapp_off

# Setup firewall rules to allow: Master/Worker communication within cluster
setup_pkg firewalld 

for couple in 30000-32767:tcp 10250:tcp 6783:tcp 6783:udp 6784:udp; do
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

# Run join command generated at Kubernetes Master

