data "scaleway_instance_image" "centos" {
  architecture = lookup(var.available_instance_types, var.instance_type)
  name         = var.operating_system
}

resource "scaleway_instance_ip" "this" {
  # Line below is commented because "scalweay_ip resource" will
  # be used as the input parameter for "scaleway_server resource"  
  # server_id = scaleway_instance_server.this[0].id
}

resource "scaleway_instance_server" "this" {
  count = var.enabled == "true" ? 1 : 0

  name              = "k8s-${var.worker}-tf"
  image             = data.scaleway_instance_image.centos.id
  type              = var.instance_type
  tags              = ["k8s-${var.worker}-tf", "${var.worker}"]
  security_group_id = var.sg_id
  ip_id             = scaleway_instance_ip.this.id

  provisioner "file" {
    source      = "${path.module}/../../conf/"
    destination = "/opt/"

    connection {
      type = "ssh"
      user = "root"
      host = scaleway_instance_server.this[0].public_ip
    }
  }

  provisioner "remote-exec" {

    connection {
      type = "ssh"
      user = "root"
      host = scaleway_instance_server.this[0].public_ip
    }

    inline = [
      # This is an examle of using templatefile (useful if there is a need
      # to use soem variables in Bash, Python, etc. scripts from variables.tf)
      #
      # templatefile("${path.module}/conf/${var.worker_script_initial}", {
      #   PUBLIC_IP = scaleway_instance_server.this.public_ip
      # })

      "chmod +x /opt/*.sh",
      "sleep 7",
      "/opt/${var.worker_script_initial} &> /opt/${var.worker_script_initial}.log",
      "FINAL_JOIN_CMD=$(echo ${var.expected_join_cmd} | sed -e 's/^.//' | sed 's/.\\{2\\}$//')",
      "echo $FINAL_JOIN_CMD > /opt/final_join_cmd.txt",
      "eval $FINAL_JOIN_CMD",

    ]
  }
}


