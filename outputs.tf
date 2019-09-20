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

