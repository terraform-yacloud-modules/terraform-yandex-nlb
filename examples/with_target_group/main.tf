module "network_load_balancer" {
  source = "../../"

  folder_id = "xxxx"
  region_id = "ru-central1"
  name = "example-nlb"
  description = "Network Load Balancer"
  labels = { env = "dev" }
  subnet_id = "xxxxx"
  create_pip = false
  type = "internal"
  create_target_group = true

  targets = [
    {
      subnet_id = "xxxxx"
      address = "10.130.0.3"
    }
  ]

  listeners = [
    {
      name = "listener1"
      port = 80
      target_port = 80
      protocol = "tcp"
      is_public = false
      ip_version = "ipv4"
    }
  ]

  health_check = {
    enabled = true
    name = "healthcheck"
    interval = 5
    timeout = 3
    unhealthy_threshold = 2
    healthy_threshold = 2
    http_options = {
      port = 80
      path = "/health"
    }
  }

}
