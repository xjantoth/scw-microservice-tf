output "this_scaleway_image_centos_id" {
  value       = data.scaleway_instance_image.centos.id
  description = "Os image ID"
}

output "this_scaleway_server_private_ip" {
  value       = [for val in scaleway_instance_server.this : val.private_ip]
  description = "Kubernetes Worker private ip"
}

output "this_scaleway_server_public_ip" {
  value       = [for val in scaleway_instance_server.this : val.public_ip]
  description = "Kubernetes Worker public ip"
}


