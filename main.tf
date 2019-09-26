terraform {
  required_version = "~> 0.12"
}

provider "scaleway" {
  organization = var.scw_organization
  token        = var.scw_token
  region       = var.scw_region
}

module "security_group" {
  source = "./modules/security_group"
}

module "k8s_master" {
  source                   = "./modules/k8s_master"
  sg_id                    = module.security_group.this_security_group_id
  instance_type            = var.instance_type
  available_instance_types = var.available_instance_types
  operating_system         = var.operating_system
  cloudinit_script_name    = var.cloudinit_script_name
  master_script_initial    = var.master_script_initial
}

module "k8s_worker" {
  source                   = "./modules/k8s_worker"
  sg_id                    = module.security_group.this_security_group_id
  instance_type            = var.instance_type
  available_instance_types = var.available_instance_types
  operating_system         = var.operating_system
  worker_script_initial    = var.worker_script_initial
  worker                   = var.worker
  expected_join_cmd        = module.k8s_master.join_command
}