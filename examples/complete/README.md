# Полный пример Network Load Balancer

Пример показывает все основные возможности модуля
[`terraform-yandex-nlb`](https://github.com/terraform-yacloud-modules/terraform-yandex-nlb):

- внешний балансировщик с публичным IP-адресом, создаваемым модулем;
- два слушателя TCP (HTTP и HTTPS);
- внутренний балансировщик с приватным слушателем и статическим внутренним IP-адресом;
- собственные целевые группы с отдельными именем, описанием и метками;
- HTTP- и TCP-проверки работоспособности;
- таймауты операций и метки ресурсов.

## Использование

```bash
export YC_FOLDER_ID='folder_id'
terraform init
terraform plan
terraform apply
```

`folder_id` задаётся в `terraform.tfvars` (или передаётся как переменная `-var folder_id=...` /
через Terragrunt `inputs`).

Пример создаёт ресурсы, которые могут стоить денег. Когда они больше не нужны, выполните:

```bash
terraform destroy
```
