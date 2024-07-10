resource "yandex_lb_network_load_balancer" "main" {
  name        = var.name
  description = var.description
  folder_id   = var.folder_id
  labels      = var.labels

  region_id = var.region_id
  type      = var.type

  dynamic "listener" {
    for_each = var.listeners
    content {
      name        = listener.value["name"]
      port        = listener.value["port"]
      target_port = listener.value["target_port"]
      protocol    = listener.value["protocol"]

      dynamic "external_address_spec" {
        for_each = listener.value["is_public"] ? [1] : []
        content {
          address    = yandex_vpc_address.pip[0].external_ipv4_address[0].address
          ip_version = listener.value["ip_version"]
        }
      }

      dynamic "internal_address_spec" {
        for_each = !listener.value["is_public"] ? [1] : []
        content {
          subnet_id  = var.subnet_id
          ip_version = listener.value["ip_version"]
        }
      }
    }
  }

  dynamic "attached_target_group" {
    for_each = var.create_target_group ? concat(var.target_group_ids, [yandex_lb_target_group.main[0].id]) : var.target_group_ids
    content {
      target_group_id = attached_target_group.value

      dynamic "healthcheck" {
        for_each = var.health_check.enabled ? [1] : []
        content {
          name                = var.health_check.name
          interval            = var.health_check.interval
          timeout             = var.health_check.timeout
          unhealthy_threshold = var.health_check.unhealthy_threshold
          healthy_threshold   = var.health_check.healthy_threshold

          dynamic "http_options" {
            for_each = lookup(var.health_check, "http_options") != null ? [
              1
            ] : []
            content {
              port = var.health_check.http_options.port
              path = var.health_check.http_options.path
            }
          }

          dynamic "tcp_options" {
            for_each = lookup(var.health_check, "tcp_options") != null ? [
              1
            ] : []
            content {
              port = var.health_check.tcp_options.port
            }
          }
        }
      }
    }
  }
}

resource "yandex_lb_target_group" "main" {
  count = var.create_target_group ? 1 : 0

  name        = var.name
  description = var.description
  folder_id   = var.folder_id
  labels      = var.labels

  region_id = var.region_id

  dynamic "target" {
    for_each = var.targets
    content {
      subnet_id = target.value["subnet_id"]
      address   = target.value["address"]
    }
  }
}
