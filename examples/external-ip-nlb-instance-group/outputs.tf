output "instance_group_id" {
  description = "Compute instance group ID"
  value       = module.yandex_compute_instance.instance_group_id
}

output "ssh_key_pub" {
  description = "Public SSH key"
  sensitive   = true
  value       = module.yandex_compute_instance.ssh_key_pub
}

output "ssh_key_prv" {
  description = "Private SSH key"
  sensitive   = true
  value       = module.yandex_compute_instance.ssh_key_prv
}

output "target_group_id" {
  description = "Target group ID"
  value       = module.yandex_compute_instance.target_group_id
}

output "nlb_external_ip" {
  description = "External IP address of the Network Load Balancer"
  value       = module.network_load_balancer.external_ip
}

output "external_ipv4" {
  description = "External IPv4 address details"
  value       = module.address.external_ipv4_address
}
