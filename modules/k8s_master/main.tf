data "scaleway_image" "centos" {
  architecture = lookup(var.available_instance_types, var.instance_type)
  name         = var.operating_system
}

resource "scaleway_ip" "this" {
  # Line below is commented because "scalweay_ip resource" will
  # be used as the input parameter for "scaleway_server resource"  
  # server = "${scaleway_server.k8s-master.id}"
}

# I do not know how to take advantage out of this section yet (cloudinit)
data "local_file" "cloudinit_file" {
  filename = "${path.module}/../../conf/${var.cloudinit_script_name}"
}


resource "scaleway_server" "this" {
  name           = "k8s-master-tf"
  image          = data.scaleway_image.centos.id
  type           = var.instance_type
  tags           = ["k8s-master-tf"]
  cloudinit      = data.local_file.cloudinit_file.content
  public_ip      = scaleway_ip.this.ip
  security_group = var.sg_id

  provisioner "file" {
    # copying all files from conf/ folder
    source      = "${path.module}/../../conf/"
    destination = "/opt/"

    connection {
      type = "ssh"
      user = "root"
      host = scaleway_ip.this.ip
    }
  }

  provisioner "remote-exec" {

    connection {
      type = "ssh"
      user = "root"
      host = scaleway_ip.this.ip
    }

    inline = [
      # This is an examle of using templatefile (useful if there is a need
      # to use soem variables in Bash, Python, etc. scripts from variables.tf)
      #
      # templatefile("${path.module}/conf/${var.master_script_initial}", {
      #   PUBLIC_IP = scaleway_server.this.public_ip
      # })

      "chmod +x /opt/*.sh",
      "sleep 7",
      "/opt/${var.master_script_initial} &> /opt/${var.master_script_initial}.log",


    ]
  }
}




