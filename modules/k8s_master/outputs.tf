output "this_scaleway_image_centos_id" {
  value       = data.scaleway_image.centos.id
  description = "Os image ID"
}

output "this_scaleway_server_private_ip" {
  value       = scaleway_instance_server.this[0].private_ip
  description = "Kubernetes Master private ip"
}

output "this_scaleway_server_public_ip" {
  value       = scaleway_instance_server.this[0].public_ip
  description = "Kubernetes Master public ip"
}

output "join_command" {
  value       = data.external.join_cmd.result.cmd
  description = "Join command to be executed at Worker server"
}


