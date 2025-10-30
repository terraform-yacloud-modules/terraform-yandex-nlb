#
# yandex cloud coordinates
#
variable "folder_id" {
  description = "ID of the folder where the resources will be created"
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

variable "create_pip" {
  description = "If true, public IP will be created"
  type        = bool
  default     = true
}

variable "pip_zone_id" {
  description = "Public IP zone"
  type        = string
  default     = "ru-central1-a"
}

#
# load balancer configuration
#
variable "type" {
  description = "Network load balancer type; Can be internal or external"
  type        = string
  default     = "internal"

  validation {
    condition     = contains(["internal", "external"], var.type)
    error_message = "Type must be either 'internal' or 'external'."
  }
}

variable "deletion_protection" {
  description = "Protection against accidental deletion of the network load balancer"
  type        = bool
  default     = false
}

variable "allow_zonal_shift" {
  description = "Allow zonal shift for the network load balancer"
  type        = bool
  default     = false
}

variable "listeners" {
  description = "Network load balancer listeners"
  type = list(object({
    name        = optional(string)
    port        = optional(number)
    target_port = optional(number)
    protocol    = optional(string, "tcp")
    is_public   = optional(bool, false)
    ip_version  = optional(string, "ipv4")
  }))
  default = []

  validation {
    condition = alltrue([
      for listener in var.listeners : contains(["tcp", "udp"], listener.protocol)
    ])
    error_message = "Listener protocol must be either 'tcp' or 'udp'."
  }

  validation {
    condition = alltrue([
      for listener in var.listeners : contains(["ipv4", "ipv6"], listener.ip_version)
    ])
    error_message = "IP version must be either 'ipv4' or 'ipv6'."
  }

  validation {
    condition = alltrue([
      for listener in var.listeners : listener.port == null || (listener.port >= 1 && listener.port <= 65535)
    ])
    error_message = "Listener port must be in the range of 1 to 65535."
  }

  validation {
    condition = alltrue([
      for listener in var.listeners : listener.target_port == null || (listener.target_port >= 0 && listener.target_port <= 65535)
    ])
    error_message = "Target port must be in the range of 0 to 65535."
  }
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

  validation {
    condition     = var.health_check.interval == null || (var.health_check.interval >= 2 && var.health_check.interval <= 300)
    error_message = "Health check interval must be in the range of 2s to 5m (300s)."
  }

  validation {
    condition     = var.health_check.timeout == null || (var.health_check.timeout >= 1 && var.health_check.timeout <= 60)
    error_message = "Health check timeout must be in the range of 1s to 1m (60s)."
  }

  validation {
    condition     = var.health_check.http_options == null || var.health_check.http_options.port == null || (var.health_check.http_options.port >= 1 && var.health_check.http_options.port <= 65535)
    error_message = "HTTP health check port must be in the range of 1 to 65535."
  }

  validation {
    condition     = var.health_check.tcp_options == null || var.health_check.tcp_options.port == null || (var.health_check.tcp_options.port >= 1 && var.health_check.tcp_options.port <= 65535)
    error_message = "TCP health check port must be in the range of 1 to 65535."
  }
}

variable "pip" {
  description = "Public IP address for the network load balancer"
  type        = string
  default     = null
}

variable "timeouts" {
  description = "Timeout configuration for resource operations"
  type = object({
    create = optional(string, "10m")
    update = optional(string, "10m")
    delete = optional(string, "15m")
  })
  default = {}
}

variable "pip_deletion_protection" {
  description = "Protection against accidental deletion of the public IP address"
  type        = bool
  default     = false
}
