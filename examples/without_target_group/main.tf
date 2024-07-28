module "network_load_balancer" {
  source = "../../"

  region_id   = "ru-central1"           # ID региона
  name        = "example-nlb"           # Название балансировщика
  description = "Network Load Balancer" # Описание
  labels      = { env = "dev" }         # Метки

  subnet_id   = "xxxx"                  # ID подсети

  create_pip  = false                   # Создавать ли публичный IP

  type = "internal"                     # Тип балансировщика (internal или external)

  create_target_group = false
}

