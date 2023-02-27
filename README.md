# Yandex Cloud Network Load Balancer Terraform module

Terraform module which creates Yandex Cloud Network Load Balancer resources.

## Examples

Examples codified under
the [`examples`](https://github.com/terraform-yacloud-modules/terraform-yandex-nlb/tree/main/examples) are intended
to give users references for how to use the module(s) as well as testing/validating changes to the source code of the
module. If contributing to the project, please be sure to make any appropriate updates to the relevant examples to allow
maintainers to test your changes and to keep the examples up to date for users. Thank you!

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [yandex_lb_network_load_balancer.main](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/lb_network_load_balancer) | resource |
| [yandex_lb_target_group.main](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/lb_target_group) | resource |
| [yandex_vpc_address.pip](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_address) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_target_group"></a> [create\_target\_group](#input\_create\_target\_group) | If true, target group will be created | `bool` | `false` | no |
| <a name="input_description"></a> [description](#input\_description) | Network load balancer description | `string` | `""` | no |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | Folder ID | `string` | `null` | no |
| <a name="input_health_check"></a> [health\_check](#input\_health\_check) | Target group health check | <pre>object({<br>    enabled             = optional(bool, false)<br>    name                = string<br>    interval            = optional(number, 2)<br>    timeout             = optional(number, 1)<br>    unhealthy_threshold = optional(number, 2)<br>    healthy_threshold   = optional(number, 3)<br>    http_options = optional(object({<br>      port = optional(number)<br>      path = optional(string, "/")<br>    }), null)<br>    tcp_options = optional(object({<br>      port = optional(number)<br>    }), null)<br>  })</pre> | <pre>{<br>  "name": "app"<br>}</pre> | no |
| <a name="input_labels"></a> [labels](#input\_labels) | A set of labels | `map(string)` | `{}` | no |
| <a name="input_listeners"></a> [listeners](#input\_listeners) | Network load balancer listeners | <pre>list(object({<br>    name        = optional(string)<br>    port        = optional(number)<br>    target_port = optional(number)<br>    protocol    = optional(string, "tcp")<br>    external_address_spec = optional(object({<br>      allocate_pip = optional(bool, false)<br>      pip_zone_id  = optional(string)<br>      address      = optional(string)<br>      ip_version   = optional(string, "ipv4")<br>    }), {})<br>    internal_address_spec = optional(object({<br>      address    = optional(string)<br>      ip_version = optional(string, "ipv4")<br>    }), {})<br>  }))</pre> | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Network load balancer name | `string` | n/a | yes |
| <a name="input_region_id"></a> [region\_id](#input\_region\_id) | ID of the availability zone where the network load balancer resides | `string` | `null` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Private subnet where IP for NLB listener will be allocated | `string` | `null` | no |
| <a name="input_target_group_ids"></a> [target\_group\_ids](#input\_target\_group\_ids) | IDs of target groups that will be attached to Network Load Balancer | `list(string)` | `[]` | no |
| <a name="input_targets"></a> [targets](#input\_targets) | Network load balancer targets | <pre>list(object({<br>    address   = string<br>    subnet_id = string<br>  }))</pre> | `[]` | no |
| <a name="input_type"></a> [type](#input\_type) | Network load balancer type; Can be internal or external | `string` | `"internal"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | Network Load Balancer ID |
| <a name="output_name"></a> [name](#output\_name) | Network Load Balancer name |
| <a name="output_tg_id"></a> [tg\_id](#output\_tg\_id) | Target group ID |
| <a name="output_tg_name"></a> [tg\_name](#output\_tg\_name) | Target group name |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache-2.0 Licensed.
See [LICENSE](https://github.com/terraform-yacloud-modules/terraform-yandex-nlb/blob/main/LICENSE).
