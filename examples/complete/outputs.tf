output "nlb_external_id" {
  description = "External Network Load Balancer ID"
  value       = module.network_load_balancer_external.id
}

output "nlb_external_ip" {
  description = "External IP address of the external Network Load Balancer"
  value       = module.network_load_balancer_external.external_ip
}

output "nlb_external_target_group_id" {
  description = "Target group ID of the external Network Load Balancer"
  value       = module.network_load_balancer_external.tg_id
}

output "nlb_internal_id" {
  description = "Internal Network Load Balancer ID"
  value       = module.network_load_balancer_internal.id
}

output "nlb_internal_target_group_id" {
  description = "Target group ID of the internal Network Load Balancer"
  value       = module.network_load_balancer_internal.tg_id
}

output "nlb_listener_addresses" {
  description = "IP addresses of the listeners of both Network Load Balancers"
  value = {
    external = module.network_load_balancer_external.listener_addresses
    internal = module.network_load_balancer_internal.listener_addresses
  }
}
