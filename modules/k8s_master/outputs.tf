output "this_scaleway_image_centos_id" {
  value = data.scaleway_image.centos.id
}

output "this_scaleway_server_private_ip" {
  value = scaleway_server.this.private_ip
}

output "this_scaleway_server_public_ip" {
  value = scaleway_server.this.public_ip
}

