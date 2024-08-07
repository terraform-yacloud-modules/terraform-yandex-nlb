module "iam_accounts" {
  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-iam.git//modules/iam-account?ref=v1.0.0"

  name = "iam-yandex-compute-instance-group"
  folder_roles = [
    "editor"
  ]
  cloud_roles              = []
  enable_static_access_key = false
  enable_api_key           = false
  enable_account_key       = false

}

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

module "address" {
  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-address.git"

  name    = "nlb-pip"
  zone_id = "ru-central1-a"
}

module "yandex_compute_instance" {
  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-instance-group.git?ref=v1.0.0"

  zones = ["ru-central1-a"]

  name = "example-instance-group"

  network_id = module.network.vpc_id
  subnet_ids = [module.network.private_subnets_ids[0]]
  enable_nat = true

  scale = {
    fixed = {
      size = 1
    }
  }

  max_checking_health_duration = 10

  health_check = {
    enabled             = true
    interval            = 15
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
    tcp_options = {
      port = 22
    }
  }

  platform_id   = "standard-v3"
  cores         = 2
  memory        = 4
  core_fraction = 100

  image_family = "ubuntu-2004-lts"

  enable_nlb_integration = true

  hostname           = "my-instance"
  service_account_id = module.iam_accounts.id
  ssh_user           = "ubuntu"
  generate_ssh_key   = false
  ssh_pubkey         = "~/.ssh/id_rsa.pub"

  user_data = <<-EOF
        #cloud-config
        package_upgrade: true
        packages:
          - nginx
        runcmd:
          - [systemctl, start, nginx]
          - [systemctl, enable, nginx]
        EOF

  depends_on = [module.iam_accounts]
}


module "network_load_balancer" {
  source = "../../"

  region_id           = "ru-central1"
  name                = "example-nlb"
  description         = "Network Load Balancer"
  labels              = { env = "dev" }
  subnet_id           = module.network.private_subnets_ids[0]
  create_pip          = false # Создавать ли публичный IP
  pip                 = module.address.external_ipv4_address
  type                = "external"
  create_target_group = false
  target_group_ids    = [module.yandex_compute_instance.target_group_id]

  listeners = [
    {
      name        = "listener1"
      port        = 80
      target_port = 80
      protocol    = "tcp"
      is_public   = true
      ip_version  = "ipv4"
    }
  ]

  health_check = {
    enabled = true
    name    = "http"
    http_options = {
      port = 80
      path = "/"
    }
  }
}
