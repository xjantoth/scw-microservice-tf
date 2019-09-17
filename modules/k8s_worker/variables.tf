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


variable "sg_id" {
  type        = string
  description = "Security group id"
}

variable "worker_script_initial" {
  type        = "string"
  description = "Shell script to initiate Kubernetes worker"
}

variable "worker" {
  type        = "string"
  description = "Identifies Kubernetes role: master|worker"
}

