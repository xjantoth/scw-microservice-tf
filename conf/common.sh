#!/bin/bash

function create_dir () {
  local dirName="$1"  
  if [ ! -d ${dirName} ]
  then
      mkdir -p ${dirName}
  else
    echo "Directory: ${dirName} exists!"  
  fi
}

function disable_selinux {
getenforce
setenforce 0
sed -i --follow-symlinks \
's/SELINUX=enforcing/SELINUX=disabled/g' \
/etc/sysconfig/selinux
}

function swapp_off {
  swapoff -a
  sed -i '/[^#]/ s/\(^.*swap.*$\)/#\ \1/' /etc/fstab
}

function setup_pkg () {
  local pkg="$1"
  
  yum install ${pkg} -y
  systemctl enable ${pkg} && systemctl start ${pkg}
}

function allow_fw_port () {
  local port="$1"
  local protocol="$2"

  firewall-cmd --permanent --add-port=${port}/${protocol}
}

function setup_bridge {
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sysctl --system
}

function add_yum_repo {
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF
}

function install_helm {
  curl https://raw.githubusercontent.com/helm/helm/master/scripts/get > get_helm.sh
  chmod 700 get_helm.sh
  ./get_helm.sh
}

function generate_certs {
  CERTS_DIR="/opt/certs"
  create_dir ${CERTS_DIR}
  
  cd ${CERTS_DIR}

  # Create CA authority
  openssl genrsa -out ca.key.pem 4096
  openssl req -key ca.key.pem -subj "/C=EU/ST=SD/L=AM/O=devopsinuse/CN=Authority" -new -x509 -days 7300 -sha256 -out ca.cert.pem -extensions v3_ca

  # Generate keys for tiller && helm
  openssl genrsa -out tiller.key.pem 4096
  openssl genrsa -out helm.key.pem 4096
  
  # Generate CSR tiller && helm
  openssl req -key tiller.key.pem -new -sha256 -out tiller.csr.pem -subj "/C=EU/ST=SD/L=AM/O=devopsinuse/CN=tiller"
  openssl req -key helm.key.pem -new -sha256 -out helm.csr.pem -subj "/C=EU/ST=SD/L=AM/O=devopsinuse/CN=tiller"

  # Sign CSR with self-signed CA
  openssl x509 -req -CA ca.cert.pem -CAkey ca.key.pem -CAcreateserial -in tiller.csr.pem -out tiller.cert.pem -days 365
  openssl x509 -req -CA ca.cert.pem -CAkey ca.key.pem -CAcreateserial -in helm.csr.pem -out helm.cert.pem  -days 365

}

function create_sa_crb {
# Create tiller account and clusterrolebinding
cat <<EOF > rbac-tiller-config.yaml
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: tiller
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: tiller
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: tiller
    namespace: kube-system
EOF
}

function secure_helm_tiller {
echo  -e "\nGenerating certificates"
generate_certs
echo -e "\nCreating ServiceAccount and CRB"
create_sa_crb
kubectl create -f rbac-tiller-config.yaml

# Allow application scheduling on Kubernetes master
kubectl taint nodes --all node-role.kubernetes.io/master-

HELMINIT="/opt/helm-init.yaml"

# Deploy tiller pod with SSL
helm init \
--service-account=tiller \
--tiller-tls \
--tiller-tls-cert ./tiller.cert.pem \
--tiller-tls-key ./tiller.key.pem \
--tiller-tls-verify \
--tls-ca-cert \
ca.cert.pem \
-o yaml > ${HELMINIT}

sed -i 's@apiVersion: extensions/v1beta1@apiVersion: apps/v1@' ${HELMINIT}
sed -i '/^\s*kind:\s*Deployment/,/^\s*template/s/^\(\s*spec:\s*\)/\1 \n  selector:\n    matchLabels:\n      name: tiller/'  ${HELMINIT}
kubectl apply -f ${HELMINIT}

echo -e "helm ls --tls --tls-ca-cert ca.cert.pem --tls-cert helm.cert.pem --tls-key helm.key.pem"
echo -e "executing: cp helm.cert.pem ~/.helm/cert.pem"
create_dir ~/.helm
yes | cp -rf ${CERTS_DIR}/helm.cert.pem ~/.helm/cert.pem
echo -e "executing: cp helm.key.pem ~/.helm/key.pem"
yes | cp -rf ${CERTS_DIR}/helm.key.pem ~/.helm/key.pem
cd ..
}

