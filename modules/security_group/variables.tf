variable "sg_name" {
  type        = string
  description = "Security group name"
}
variable "allowed_tcp_ports" {
  description = "List of allowed TCP Firewall Ports - Kubernetes NodePorts"
  type        = list
}

variable "allowed_udp_ports" {
  description = "List of allowed UDP Firewall Ports - Kubernetes NodePorts"
  type        = list
}



