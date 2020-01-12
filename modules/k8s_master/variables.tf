variable "instance_type" {
  type        = string
  description = "Desired development instance type"
}

variable "available_instance_types" {
  type        = map(string)
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

variable "sg_id" {
  type        = string
  description = "Security group id"
}

variable "master_script_initial" {
  type        = string
  description = "Shell script to initiate Kubernetes master"
}

variable "master" {
  type        = string
  description = "Identifies Kubernetes role: master"
}

variable "enabled" {
  description = "Flag to enable or disable this resource"
}