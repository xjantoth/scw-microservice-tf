terraform {
  required_version = "~> 0.12"
}

provider "scaleway" {
  organization = var.scw_organization
  token        = var.scw_token
  region       = var.scw_region
}

data "scaleway_image" "centos" {
  architecture = lookup(var.available_instance_types, var.instance_type)
  name         = var.operating_system

}

resource "scaleway_ip" "ip" {
  server = "${scaleway_server.k8s-master.id}"
}

data "local_file" "cloudinit_file" {
  filename = "${path.module}/${var.cloudinit_script_name}"
}

resource "scaleway_server" "k8s-master" {
  name      = "k8s-master-tf"
  image     = data.scaleway_image.centos.id
  type      = var.instance_type
  tags      = ["k8s-master-tf"]
  cloudinit = data.local_file.cloudinit_file.content
}


