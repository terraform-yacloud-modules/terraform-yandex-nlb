data "yandex_client_config" "client" {}

provider "yandex" {
}

module "network" {
  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-vpc.git?ref=v1.0.0"

  folder_id = coalesce(var.folder_id, data.yandex_client_config.client.folder_id)

  blank_name = "vpc-nlb-complete"
  labels = {
    repo = "terraform-yacloud-modules/terraform-yandex-vpc"
  }

  azs = ["ru-central1-d"]

  private_subnets = [["10.24.0.0/24"]]

  create_vpc         = true
  create_nat_gateway = false
}

# External load balancer: public listeners, own public IP address, custom
# target group name/description/labels and a full health check configuration.
module "network_load_balancer_external" {
  source = "../../"

  region_id   = "ru-central1"
  name        = "example-nlb-complete-external"
  description = "External Network Load Balancer created by the complete example"
  labels      = { env = "test", example = "complete" }

  type                = "external"
  create_pip          = true
  pip_zone_id         = "ru-central1-d"
  create_target_group = true

  target_group_name        = "example-nlb-complete-external-tg"
  target_group_description = "Target group with a custom name from the complete example"
  target_group_labels      = { env = "test", role = "external-targets" }

  targets = [
    {
      subnet_id = module.network.private_subnets_ids[0]
      address   = "10.24.0.10"
    }
  ]

  listeners = [
    {
      name        = "http"
      port        = 80
      target_port = 8080
      protocol    = "tcp"
      is_public   = true
      ip_version  = "ipv4"
    },
    {
      name        = "https"
      port        = 443
      target_port = 8443
      protocol    = "tcp"
      is_public   = true
      ip_version  = "ipv4"
    }
  ]

  health_check = {
    enabled             = true
    name                = "http"
    interval            = 5
    timeout             = 3
    unhealthy_threshold = 2
    healthy_threshold   = 2
    http_options = {
      port = 8080
      path = "/healthz"
    }
  }

  timeouts = {
    create = "10m"
    update = "10m"
    delete = "15m"
  }
}

# Internal load balancer: private listener with a static internal IP address,
# own target group and TCP health check.
module "network_load_balancer_internal" {
  source = "../../"

  region_id   = "ru-central1"
  name        = "example-nlb-complete-internal"
  description = "Internal Network Load Balancer created by the complete example"
  labels      = { env = "test", example = "complete" }

  type                = "internal"
  subnet_id           = module.network.private_subnets_ids[0]
  create_pip          = false
  create_target_group = true

  target_group_name        = "example-nlb-complete-internal-tg"
  target_group_description = "Internal target group from the complete example"
  target_group_labels      = { env = "test", role = "internal-targets" }

  targets = [
    {
      subnet_id = module.network.private_subnets_ids[0]
      address   = "10.24.0.20"
    }
  ]

  listeners = [
    {
      name             = "internal-http"
      port             = 8080
      target_port      = 80
      protocol         = "tcp"
      is_public        = false
      ip_version       = "ipv4"
      internal_address = "10.24.0.50"
    }
  ]

  health_check = {
    enabled             = true
    name                = "tcp"
    interval            = 5
    timeout             = 3
    unhealthy_threshold = 2
    healthy_threshold   = 2
    tcp_options = {
      port = 80
    }
  }
}
