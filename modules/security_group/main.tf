resource "scaleway_security_group" "this" {
  name        = "kubernetes_security_group"
  description = "Security group for Kubernetes nodes."
}

resource "scaleway_security_group_rule" "this" {
  security_group = "${scaleway_security_group.this.id}"

  action    = "drop"
  direction = "inbound"
  ip_range  = "0.0.0.0/0"
  protocol  = "TCP"

  port  = "${element(var.node_ports, count.index)}"
  count = "${length(var.node_ports)}"

}
