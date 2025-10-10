module "wrapper" {
  source = "../"

  for_each = var.items

  create_pip          = try(each.value.create_pip, var.defaults.create_pip, true)
  create_target_group = try(each.value.create_target_group, var.defaults.create_target_group, false)
  description         = try(each.value.description, var.defaults.description, "")
  health_check        = try(each.value.health_check, var.defaults.health_check, { name = "app" })
  labels              = try(each.value.labels, var.defaults.labels, {})
  listeners           = try(each.value.listeners, var.defaults.listeners, [])
  name                = try(each.value.name, var.defaults.name, null)
  pip_zone_id         = try(each.value.pip_zone_id, var.defaults.pip_zone_id, "ru-central1-a")
  region_id           = try(each.value.region_id, var.defaults.region_id, null)
  subnet_id           = try(each.value.subnet_id, var.defaults.subnet_id, null)
  targets             = try(each.value.targets, var.defaults.targets, [])
  target_group_ids    = try(each.value.target_group_ids, var.defaults.target_group_ids, [])
  type                = try(each.value.type, var.defaults.type, "internal")
}
