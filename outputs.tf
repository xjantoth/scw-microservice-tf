output "os_image_id" {
  value = data.scaleway_image.centos.id
}

output "k8s-master-private-ip" {
  value = scaleway_server.k8s-master.private_ip
}

output "k8s-master-public-ip" {
  value = scaleway_server.k8s-master.public_ip
}