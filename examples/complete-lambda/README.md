<!-- BEGIN_TF_DOCS -->
## Requirements

| Name                                                                      | Version  |
|---------------------------------------------------------------------------|----------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws)                   | >= 4.0.0 |

## Providers

| Name                                              | Version |
|---------------------------------------------------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.23.0  |

## Modules

| Name                                                                          | Source                                        | Version |
|-------------------------------------------------------------------------------|-----------------------------------------------|---------|
| <a name="module_lambda"></a> [lambda](#module\_lambda)                        | git@github.com:oozou/terraform-aws-lambda.git | v1.1.0  |
| <a name="module_state_machine"></a> [state\_machine](#module\_state\_machine) | ../../                                        | n/a     |

## Resources

| Name                                                                                                                          | Type        |
|-------------------------------------------------------------------------------------------------------------------------------|-------------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region)                   | data source |

## Inputs

| Name                                                                  | Description                                                                                                  | Type       | Default | Required |
|-----------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------|------------|---------|:--------:|
| <a name="input_custom_tags"></a> [custom\_tags](#input\_custom\_tags) | Custom tags which can be passed on to the AWS resources. They should be key value pairs having distinct keys | `map(any)` | `{}`    |    no    |
| <a name="input_environment"></a> [environment](#input\_environment)   | Environment Variable used as a prefix                                                                        | `string`   | n/a     |   yes    |
| <a name="input_name"></a> [name](#input\_name)                        | Name of the ECS cluster and s3 also redis to create                                                          | `string`   | n/a     |   yes    |
| <a name="input_prefix"></a> [prefix](#input\_prefix)                  | The prefix name of customer to be displayed in AWS console and resource                                      | `string`   | n/a     |   yes    |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
