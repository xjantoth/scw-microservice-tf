terraform {
  required_version = "~> 0.12"
}

provider "scaleway" {
  version = "~> 1.11"
  # version         = "~> 2.0"
  access_key      = var.scw_access_key
  secret_key      = var.scw_token
  organization_id = var.scw_organization
  zone            = var.scw_zone
  region          = var.scw_region
}

module "security_group" {
  source            = "./modules/security_group"
  sg_name           = "k8s-microservice"
  allowed_tcp_ports = var.allowed_tcp_ports
  allowed_udp_ports = var.allowed_udp_ports
}

module "k8s_master" {
  source                   = "./modules/k8s_master"
  enabled                  = var.master_enabled
  sg_id                    = module.security_group.this_security_group_id
  instance_type            = var.instance_type
  available_instance_types = var.available_instance_types
  operating_system         = var.operating_system
  cloudinit_script_name    = var.cloudinit_script_name
  master_script_initial    = var.master_script_initial
  master                   = var.master
}

module "k8s_worker" {
  enabled                  = var.worker_enabled
  source                   = "./modules/k8s_worker"
  sg_id                    = module.security_group.this_security_group_id
  instance_type            = var.instance_type
  available_instance_types = var.available_instance_types
  operating_system         = var.operating_system
  worker_script_initial    = var.worker_script_initial
  worker                   = var.worker
  expected_join_cmd        = module.k8s_master.join_command
}

