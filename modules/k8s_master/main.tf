data "scaleway_image" "centos" {
  architecture = lookup(var.available_instance_types, var.instance_type)
  name         = var.operating_system
}

resource "scaleway_ip" "this" {
  # server = "${scaleway_server.k8s-master.id}"
}

# I do not know how to take advantage out of this section yet
data "local_file" "cloudinit_file" {
  filename = var.cloudinit_script_name
}


resource "scaleway_server" "this" {
  name           = "k8s-master-tf"
  image          = data.scaleway_image.centos.id
  type           = var.instance_type
  tags           = ["k8s-master-tf"]
  cloudinit      = data.local_file.cloudinit_file.content
  public_ip      = scaleway_ip.this.ip
  security_group = var.sg_id

  provisioner "remote-exec" {

    connection {
      type = "ssh"
      user = "root"
      host = scaleway_ip.this.ip
    }
    inline = [
      "mkdir -p /etc/test-scw-x",
      templatefile("${path.module}/conf/shell-script-example.sh.tpl", {
        PUBLIC_IP = scaleway_server.this.public_ip
      })
    ]
  }
}


