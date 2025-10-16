data "yandex_client_config" "client" {}

module "network" {
  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-vpc.git?ref=v1.0.0"

  folder_id = data.yandex_client_config.client.folder_id

  blank_name = "vpc-nat-gateway"
  labels = {
    repo = "terraform-yacloud-modules/terraform-yandex-vpc"
  }

  azs = ["ru-central1-a", "ru-central1-b", "ru-central1-d"]

  private_subnets = [["10.24.0.0/24"], ["10.25.0.0/24"], ["10.26.0.0/24"]]

  create_vpc         = true
  create_nat_gateway = true
}

module "network_load_balancer" {
  source = "../../"

  region_id           = "ru-central1"
  name                = "example-nlb"
  description         = "Network Load Balancer"
  labels              = { env = "dev" }
  subnet_id           = module.network.private_subnets_ids[0]
  create_pip          = false
  type                = "internal"
  create_target_group = true

  targets = [
    {
      subnet_id = module.network.private_subnets_ids[0]
      address   = "10.24.0.2"
    }
  ]

  listeners = [
    {
      name        = "listener1"
      port        = 80
      target_port = 80
      protocol    = "tcp"
      is_public   = false
      ip_version  = "ipv4"
    }
  ]

  health_check = {
    enabled             = true
    name                = "healthcheck"
    interval            = 5
    timeout             = 3
    unhealthy_threshold = 2
    healthy_threshold   = 2
    http_options = {
      port = 80
      path = "/health"
    }
  }

}
