data "scaleway_instance_image" "centos" {
  architecture = lookup(var.available_instance_types, var.instance_type)
  name         = var.operating_system
}

resource "scaleway_instance_ip" "this" {
  # Line below is commented because "scalweay_ip resource" will
  # be used as the input parameter for "scaleway_server resource"  
  # server_id = scaleway_instance_server.this[0].id
}

# I do not know how to take advantage out of this section yet (cloudinit)
data "local_file" "cloudinit_file" {
  filename = "${path.module}/../../conf/${var.cloudinit_script_name}"
}


resource "scaleway_instance_server" "this" {
  count = var.enabled == "true" ? 1 : 0

  name              = "k8s-${var.master}-tf"
  image             = data.scaleway_instance_image.centos.id
  type              = var.instance_type
  tags              = ["k8s-${var.master}-tf", "${var.master}"]
  cloud_init        = data.local_file.cloudinit_file.content
  security_group_id = var.sg_id
  ip_id             = scaleway_instance_ip.this.id

  provisioner "file" {
    # copying all files from conf/ folder
    source      = "${path.module}/../../conf/" # my local code
    destination = "/opt/"                      # remote server

    connection {
      type = "ssh"
      user = "root"
      private_key = file("~/.ssh/k8s-scw")
      agent = false
      timeout     = "5m"
      host = scaleway_instance_server.this[0].public_ip
    }
  }

  provisioner "remote-exec" {

    connection {
      type = "ssh"
      user = "root"
      private_key = file("~/.ssh/k8s-scw")
      agent = false
      timeout     = "5m"
      host = scaleway_instance_server.this[0].public_ip
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

# SSH to Master node and executes 
# [root@k8s-master-tf ~]# kubeadm token create --print-join-command
# retrived this value will be used at k8s-worker-tf server
# to join to Single node Kubernetes cluster

# data "external" "join_cmd" {
#   # count   = "${var.enabled == "true" ? 1 : 0}"
#   program = ["python", "${path.module}/../../conf/exdata.py"]

#   query = {
#     host = "${scaleway_instance_server.this[0].public_ip}"
#   }
#   depends_on = [scaleway_instance_server.this]
# }


