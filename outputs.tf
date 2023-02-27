output "id" {
  description = "Network Load Balancer ID"
  value       = yandex_lb_network_load_balancer.main.id
}

output "name" {
  description = "Network Load Balancer name"
  value       = yandex_lb_network_load_balancer.main.name
}

output "tg_id" {
  description = "Target group ID"
  value       = var.create_target_group ? yandex_lb_target_group.main[0].id : null
}

output "tg_name" {
  description = "Target group name"
  value       = var.create_target_group ? yandex_lb_target_group.main[0].name : null
}
