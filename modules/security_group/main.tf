resource "scaleway_instance_security_group" "this" {
  inbound_default_policy = "accept" 
  # By default we drop incomming trafic 
  # that do not match any inbound_rule.

  name        = "k8s_security_group"
  description = "Allowing port used K8s servers"

  # count = "${length(var.node_ports)}"

  inbound_rule {
    action   = "accept"
    ip_range = "0.0.0.0/0"
    protocol = "TCP"
    port     = 22
  }


}
