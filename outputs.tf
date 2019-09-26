# Master outputs
output "master_scaleway_image_centos_id" {
  value       = module.k8s_master.this_scaleway_image_centos_id
  description = "Os image ID"
}

output "master_scaleway_server_private_ip" {
  value       = module.k8s_master.this_scaleway_server_private_ip
  description = "Kubernetes Master private ip"
}

output "master_scaleway_server_public_ip" {
  value       = module.k8s_master.this_scaleway_server_public_ip
  description = "Kubernetes Master public ip"
}

output "join_command" {
  value       = module.k8s_master.join_command
  description = "Join command (retrivet from Master) to be executed at Worker server"
}


# Worker outputs
output "worker_scaleway_image_centos_id" {
  value       = module.k8s_worker.this_scaleway_image_centos_id
  description = "Os image ID"
}

output "worker_scaleway_server_private_ip" {
  value       = module.k8s_worker.this_scaleway_server_private_ip
  description = "Kubernetes Worker private ip"
}

output "worker_scaleway_server_public_ip" {
  value       = module.k8s_worker.this_scaleway_server_public_ip
  description = "Kubernetes Worker public ip"
}



