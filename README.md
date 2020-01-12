# Project structure


```bash
curl 'https://api-marketplace.scaleway.com/images?arch=x86_64'  | jq -r '.images[].name'

git clone https://github.com/xjantoth/scw-microservice-tf

main.tf
variables.tf
outputs.tf
terraform.scw.tfvars (optional - personal preference)
modules/
conf/
```

```bash
 tree -L 2
.
├── conf
│   ├── cloudinit.sh
│   ├── common.sh
│   ├── exdata.py
│   ├── __init__.py
│   ├── __pycache__
│   ├── setup_master.sh
│   └── setup_worker.sh
├── main.tf
├── modules
│   ├── k8s_master
│   ├── k8s_worker
│   └── security_group
├── outputs.tf
├── README.md
├── terraform.scw.tfvars
├── terraform.scw.tfvars.sample
├── terraform.tfstate
├── terraform.tfstate.backup
└── variables.tf

6 directories, 14 files
```

## How to run terraform code with -var-file option

```bash

ssh-keygen -f ~/.ssh/k8s-scw -C scw@k8s -t rsa -b 2048
chmod 400 ~/.ssh/k8s-scw
killall ssh-agent
ssh-add  ~/.ssh/k8s-scw  #Lswc



terraform fmt -recursive
terraform validate
terraform plan  -var-file=terraform.scw.tfvars 
terraform apply  -var-file=terraform.scw.tfvars 
terraform destroy  -var-file=terraform.scw.tfvars 
TF_LOG=debug terraform plan  -var-file=terraform.scw.tfvars
```

## Create terraform.scw.tfvars

```bash
scw_token             = "..."
scw_access_key        = "..."
scw_organization      = "..."
scw_zone              = "fr-par-1"
scw_region            = "fr-par"
operating_system      = "CentOS 7.6"
instance_type         = "DEV1-S"
cloudinit_script_name = "cloudinit.sh"
master_script_initial = "setup_master.sh"
worker_script_initial = "setup_worker.sh"
worker                = "worker-1"
master                = "master-1"
worker_enabled        = "true"
master_enabled        = "true"
allowed_tcp_ports     = ["30111", "30222", "30333", "30444", "22", "6443", "10250", "10251", "10252", "6783", "6784", "2379", "2380"]
allowed_udp_ports     = ["6783"]
```

## Install scaleway-cli

```bash
yay -Ss scaleway-cli
yay -S terraform-docs
sudo pip install pre-commit

```

## Setup pre-hooks

```bash
cat <<EOF > .pre-commit-config.yaml
- repo: git://github.com/antonbabenko/pre-commit-terraform
  rev: v1.18.0
  hooks:
    - id: terraform_fmt
    - id: terraform_docs
EOF

pre-commit install
pre-commit run -a
```