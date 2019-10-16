variable "scw_organization" {
  type        = string
  description = "Scaleway Organization"
}

variable "scw_token" {
  type        = string
  description = "Scaleway Token"
}

variable "scw_access_key" {
  type        = "string"
  description = "Scaleway Region Access Key"
}

variable "scw_region" {
  type        = string
  description = "Scaleway Region"
}

variable "scw_zone" {
  type        = string
  description = "Scaleway Region"
}

variable "instance_type" {
  type        = string
  description = "Desired development instance type"
}

variable "available_instance_types" {
  type = map(string)
  default = {
    DEV1-S = "x86_64"
    DEV1-M = "x86_64"
    DEV1-L = "x86_64"

  }
  description = "Available types for development Scaleway instances"
}

variable "operating_system" {
  type        = string
  description = "Operating system to be used"
}

variable "cloudinit_script_name" {
  type        = string
  description = "Cloudinit script name"
}

variable "master_script_initial" {
  type        = "string"
  description = "Shell script to initiate Kubernetes master"
}

variable "worker_script_initial" {
  type        = "string"
  description = "Shell script to initiate Kubernetes worker"
}

variable "worker" {
  type        = "string"
  description = "Identifies Kubernetes role: master|worker"
}

variable "master" {
  type        = "string"
  description = "Identifies Kubernetes role: master"
}

variable "master_enabled" {
  type        = "string"
  description = "Allows creation of Kubenetes Master"
}

variable "worker_enabled" {
  type        = "string"
  description = "Allows creation of Kubenetes Worker"
}


