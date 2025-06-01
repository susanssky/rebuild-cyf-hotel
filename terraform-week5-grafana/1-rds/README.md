<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_rds"></a> [rds](#module\_rds) | ./module | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_anyone_access_ip"></a> [anyone\_access\_ip](#input\_anyone\_access\_ip) | n/a | `string` | `"0.0.0.0/0"` | no |
| <a name="input_database_password"></a> [database\_password](#input\_database\_password) | n/a | `any` | n/a | yes |
| <a name="input_database_username"></a> [database\_username](#input\_database\_username) | n/a | `any` | n/a | yes |
| <a name="input_subnet_number"></a> [subnet\_number](#input\_subnet\_number) | n/a | `number` | `2` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | n/a | `string` | `"10.0.0.0/16"` | no |
| <a name="input_week_prefix"></a> [week\_prefix](#input\_week\_prefix) | n/a | `string` | `"cloud-week5"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ec2_sg_id"></a> [ec2\_sg\_id](#output\_ec2\_sg\_id) | n/a |
| <a name="output_secret_manager_arn"></a> [secret\_manager\_arn](#output\_secret\_manager\_arn) | n/a |
<!-- END_TF_DOCS -->