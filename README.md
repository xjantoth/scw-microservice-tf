# Project structure

```bash
tree -L 2
.
├── main.tf
├── modules
│   ├── k8s_master
│   └── security_group
├── outputs.tf
├── README.md
├── terraform.scw.tfvars
├── terraform.tfstate
├── terraform.tfstate.backup
└── variables.tf

3 directories, 7 files
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

```

## Install scaleway-cli

```bash
yay -Ss scaleway-cli
```
