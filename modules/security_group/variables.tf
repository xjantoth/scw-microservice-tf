variable "node_ports" {
  type        = list(string)
  default     = [30111, 30222, 30333, 30444]
  description = "NodePorts used for micro-backend, micro-frontend, ingress-controller"
}

variable "security_group" {
  type        = string
  default     = "sg_kubernetes_tf"
  description = "Security group name"

}



