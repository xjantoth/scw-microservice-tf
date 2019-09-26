# Project structure

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
├── terraform.tfstate
├── terraform.tfstate.backup
└── variables.tf

6 directories, 13 files
```

## How to run terraform code with -var-file option

```bash
terraform fmt -recursive
terraform validate
terraform plan  -var-file=terraform.scw.tfvars 
terraform apply  -var-file=terraform.scw.tfvars 
terraform destroy  -var-file=terraform.scw.tfvars 

```

## Create terraform.scw.tfvars

```bash
# General

scw_region            = "par1"
scw_token             = "..."
scw_organization      = "..."
operating_system      = "CentOS 7.6"
instance_type         = "DEV1-S"
cloudinit_script_name = "cloudinit.sh"
master_script_initial = "setup_master.sh"
worker_script_initial = "setup_worker.sh"
worker                = "worker-1"
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