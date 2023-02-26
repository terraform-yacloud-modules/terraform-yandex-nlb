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
        for_each = var.type == "external" ? [1] : []
        content {
          address    = listener.value["external_address_spec"]["allocate_pip"] ? yandex_vpc_address.pip[listener.value["name"]].external_ipv4_address[0].address : null
          ip_version = listener.value["external_address_spec"]["ip_version"]
        }
      }

      dynamic "internal_address_spec" {
        for_each = var.type == "internal" ? [1] : []
        content {
          subnet_id  = var.subnet_id
          address    = listener.value["internal_address_spec"]["address"]
          ip_version = listener.value["internal_address_spec"]["ip_version"]
        }
      }
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.main.id

    dynamic "healthcheck" {
      for_each = var.health_check.enabled ? [1] : [0]
      content {
        name                = var.health_check.name
        interval            = var.health_check.interval
        timeout             = var.health_check.timeout
        unhealthy_threshold = var.health_check.unhealthy_threshold
        healthy_threshold   = var.health_check.healthy_threshold

        dynamic "http_options" {
          for_each = lookup(var.health_check, "http_options", null) != null ? [1] : []
          content {
            port = var.health_check.http_options.port
            path = var.health_check.http_options.path
          }
        }

        dynamic "tcp_options" {
          for_each = lookup(var.health_check, "tcp_options", null) != null ? [1] : []
          content {
            port = var.health_check.tcp_options.port
          }
        }
      }
    }
  }
}

resource "yandex_lb_target_group" "main" {
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
