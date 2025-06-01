<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ec2"></a> [ec2](#module\_ec2) | ./module | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ec2_public_key"></a> [ec2\_public\_key](#input\_ec2\_public\_key) | n/a | `any` | n/a | yes |
| <a name="input_ec2_sg_id"></a> [ec2\_sg\_id](#input\_ec2\_sg\_id) | n/a | `any` | n/a | yes |
| <a name="input_secret_manager_arn"></a> [secret\_manager\_arn](#input\_secret\_manager\_arn) | n/a | `any` | n/a | yes |
| <a name="input_subnet_number"></a> [subnet\_number](#input\_subnet\_number) | n/a | `number` | `2` | no |
| <a name="input_week_prefix"></a> [week\_prefix](#input\_week\_prefix) | n/a | `string` | `"cloud-week5"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ec2_public_ip"></a> [ec2\_public\_ip](#output\_ec2\_public\_ip) | n/a |
<!-- END_TF_DOCS -->