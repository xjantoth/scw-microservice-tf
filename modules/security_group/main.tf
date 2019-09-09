resource "scaleway_security_group" "this" {
  name        = var.security_group
  description = "Allow HTTP/S and SSH traffic"
}

resource "scaleway_security_group_rule" "drop-external" {
  security_group = "${scaleway_security_group.this.id}"

  action    = "drop"
  direction = "inbound"
  ip_range  = "0.0.0.0/0"
  protocol  = "TCP"

  port  = "${element(var.node_ports, count.index)}"
  count = "${length(var.node_ports)}"

}
