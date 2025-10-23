resource "yandex_vpc_address" "pip" {
  count = var.create_pip ? 1 : 0

  name        = format("%s-alb", var.name)
  description = ""
  labels      = var.labels

  folder_id           = local.folder_id
  deletion_protection = var.pip_deletion_protection

  external_ipv4_address {
    zone_id = var.pip_zone_id
  }
}
