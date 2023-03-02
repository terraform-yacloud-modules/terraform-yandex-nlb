resource "yandex_vpc_address" "pip" {
  for_each = {
    for listener in var.listeners : listener["name"] => listener if listener["external_address_spec"]["allocate_pip"]
  }

  name = format("%s-nlb-%s", var.name, each.key)
  description = ""
  folder_id   = var.folder_id
  labels      = var.labels

  external_ipv4_address {
    zone_id = each.value["external_address_spec"]["pip_zone_id"]
  }
}
