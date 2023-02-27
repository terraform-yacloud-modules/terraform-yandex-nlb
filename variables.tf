#
# yandex cloud coordinates
#
variable "folder_id" {
  description = "Folder ID"
  type        = string
  default     = null
}

variable "region_id" {
  description = "ID of the availability zone where the network load balancer resides"
  type        = string
  default     = null
}

#
# naming
#
variable "name" {
  description = "Network load balancer name"
  type        = string
}

variable "description" {
  description = "Network load balancer description"
  type        = string
  default     = ""
}

variable "labels" {
  description = "A set of labels"
  type        = map(string)
  default     = {}
}

#
# network
#
variable "subnet_id" {
  description = "Private subnet where IP for NLB listener will be allocated"
  type        = string
  default     = null
}

#
# load balancer configuration
#
variable "type" {
  description = "Network load balancer type; Can be internal or external"
  type        = string
  default     = "internal"
}

variable "listeners" {
  description = "Network load balancer listeners"
  type = list(object({
    name        = optional(string)
    port        = optional(number)
    target_port = optional(number)
    protocol    = optional(string, "tcp")
    external_address_spec = optional(object({
      allocate_pip = optional(bool, false)
      pip_zone_id  = optional(string)
      address      = optional(string)
      ip_version   = optional(string, "ipv4")
    }), {})
    internal_address_spec = optional(object({
      address    = optional(string)
      ip_version = optional(string, "ipv4")
    }), {})
  }))
  default = []
}

variable "target_group_ids" {
  description = "IDs of target groups that will be attached to Network Load Balancer"
  type        = list(string)
  default     = []
}

variable "create_target_group" {
  description = "If true, target group will be created"
  type        = bool
  default     = false
}

variable "targets" {
  description = "Network load balancer targets"
  type = list(object({
    address   = string
    subnet_id = string
  }))
  default = []
}

variable "health_check" {
  description = "Target group health check"
  type = object({
    enabled             = optional(bool, false)
    name                = string
    interval            = optional(number, 2)
    timeout             = optional(number, 1)
    unhealthy_threshold = optional(number, 2)
    healthy_threshold   = optional(number, 3)
    http_options = optional(object({
      port = optional(number)
      path = optional(string, "/")
    }), null)
    tcp_options = optional(object({
      port = optional(number)
    }), null)
  })
  default = {
    name = "app"
  }
}
