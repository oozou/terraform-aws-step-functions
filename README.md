# terraform-aws-step-functions

## Usage

```terraform
module "state_machine" {
  source = "git::ssh://git@github.com/oozou/terraform-aws-step-functions.git?ref=<version>"

  prefix      = "oozou"
  environment = "dev"
  name        = "schedule"

  # IAM
  is_create_role             = true
  exists_role_arn            = ""  # Ignore if is_create_role is `true`
  additional_role_policy_arn = {}

  # State machine settings
  type       = "STANDARD"  # Or EXPRESS is allowed
  ## Recommendation use this; copy definition and insert here or using templatefile function
  ## https://ap-southeast-1.console.aws.amazon.com/states/home?region=ap-southeast-1#/homepage
  definition = <<EOF
{
  "Comment": "A description of my state machine",
  "StartAt": "LambdaInvoke",
  "States": {
    "LambdaInvoke": {
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "OutputPath": "$.Payload",
      "Parameters": {
        "Payload.$": "$",
        "FunctionName": "${module.lambda.function_arn}"
      },
      "Next": "CheckStatusCode"
    },
    "CheckStatusCode": {
      "Type": "Choice",
      "InputPath": "$",
      "Choices": [
        {
          "Variable": "$.statusCode",
          "NumericEquals": 500,
          "Next": "Wait"
        }
      ],
      "Default": "SuccessState"
    },
    "Wait": {
      "Type": "Wait",
      "OutputPath": "$.event",
      "Seconds": 10,
      "Next": "LambdaInvoke"
    },
    "SuccessState": {
      "Type": "Succeed"
    }
  }
}
EOF

  # Auto generate policy related to this resource
  service_integrations = {
    lambda = {
      lambda = ["${module.lambda.function_arn}*"]
    }
  }

  # Logging 
  is_create_cloudwatch_log_group = true
  log_include_execution_data     = null
  log_level                      = "ALL"
  retention_in_days              = 30

  tags = { "Workspace" = "xxx-yyy-zzz" }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name                                                                      | Version  |
|---------------------------------------------------------------------------|----------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws)                   | >= 4.00  |

## Providers

| Name                                              | Version |
|---------------------------------------------------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.19.0  |

## Modules

No modules.

## Resources

| Name                                                                                                                                               | Type        |
|----------------------------------------------------------------------------------------------------------------------------------------------------|-------------|
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group)                  | resource    |
| [aws_iam_policy.log_access_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)                         | resource    |
| [aws_iam_policy.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)                                   | resource    |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                          | resource    |
| [aws_iam_role_policy_attachment.log_acces](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource    |
| [aws_iam_role_policy_attachment.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)   | resource    |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)      | resource    |
| [aws_sfn_state_machine.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sfn_state_machine)                        | resource    |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity)                      | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)          | data source |
| [aws_iam_policy_document.log_access_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)    | data source |
| [aws_iam_policy_document.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)              | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region)                                        | data source |

## Inputs

| Name                                                                                                                                     | Description                                                                                                                   | Type           | Default      | Required |
|------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------|----------------|--------------|:--------:|
| <a name="input_additional_role_policy_arn"></a> [additional\_role\_policy\_arn](#input\_additional\_role\_policy\_arn)                   | Map of policies ARNs to attach to the lambda                                                                                  | `map(string)`  | `{}`         |    no    |
| <a name="input_attach_policies_for_integrations"></a> [attach\_policies\_for\_integrations](#input\_attach\_policies\_for\_integrations) | Whether to attach AWS Service policies to IAM role                                                                            | `bool`         | `true`       |    no    |
| <a name="input_definition"></a> [definition](#input\_definition)                                                                         | The Amazon States Language definition of the Step Function                                                                    | `string`       | n/a          |   yes    |
| <a name="input_environment"></a> [environment](#input\_environment)                                                                      | Environment Variable used as a prefix                                                                                         | `string`       | n/a          |   yes    |
| <a name="input_exists_role_arn"></a> [exists\_role\_arn](#input\_exists\_role\_arn)                                                      | The exist role arn for step functions                                                                                         | `string`       | `""`         |    no    |
| <a name="input_is_create_cloudwatch_log_group"></a> [is\_create\_cloudwatch\_log\_group](#input\_is\_create\_cloudwatch\_log\_group)     | Whether to create cloudwatch log group or not                                                                                 | `bool`         | `true`       |    no    |
| <a name="input_is_create_role"></a> [is\_create\_role](#input\_is\_create\_role)                                                         | Whether to create step function roles or not                                                                                  | `bool`         | `true`       |    no    |
| <a name="input_log_include_execution_data"></a> [log\_include\_execution\_data](#input\_log\_include\_execution\_data)                   | (Optional) Determines whether execution data is included in your log. When set to false, data is excluded.                    | `bool`         | `null`       |    no    |
| <a name="input_log_level"></a> [log\_level](#input\_log\_level)                                                                          | (Optional) Defines which category of execution history events are logged. Valid values: ALL, ERROR, FATAL, OFF                | `string`       | `"OFF"`      |    no    |
| <a name="input_name"></a> [name](#input\_name)                                                                                           | Name of the ECS cluster to create                                                                                             | `string`       | n/a          |   yes    |
| <a name="input_prefix"></a> [prefix](#input\_prefix)                                                                                     | The prefix name of customer to be displayed in AWS console and resource                                                       | `string`       | n/a          |   yes    |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days)                                                | Retention day for cloudwatch log group                                                                                        | `number`       | `30`         |    no    |
| <a name="input_service_integrations"></a> [service\_integrations](#input\_service\_integrations)                                         | Map of AWS service integrations to allow in IAM role policy                                                                   | `any`          | `{}`         |    no    |
| <a name="input_tags"></a> [tags](#input\_tags)                                                                                           | Custom tags which can be passed on to the AWS resources. They should be key value pairs having distinct keys                  | `map(any)`     | `{}`         |    no    |
| <a name="input_trusted_entities"></a> [trusted\_entities](#input\_trusted\_entities)                                                     | Step Function additional trusted entities for assuming roles (trust relationship)                                             | `list(string)` | `[]`         |    no    |
| <a name="input_type"></a> [type](#input\_type)                                                                                           | Determines whether a Standard or Express state machine is created. The default is STANDARD. Valid Values: STANDARD \| EXPRESS | `string`       | `"STANDARD"` |    no    |

## Outputs

| Name                                                                                                                        | Description                                            |
|-----------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------|
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn)                                                              | The ARN of the IAM role created for the Step Function  |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name)                                                           | The name of the IAM role created for the Step Function |
| <a name="output_state_machine_arn"></a> [state\_machine\_arn](#output\_state\_machine\_arn)                                 | The ARN of the Step Function                           |
| <a name="output_state_machine_creation_date"></a> [state\_machine\_creation\_date](#output\_state\_machine\_creation\_date) | The date the Step Function was created                 |
| <a name="output_state_machine_id"></a> [state\_machine\_id](#output\_state\_machine\_id)                                    | The ARN of the Step Function                           |
| <a name="output_state_machine_status"></a> [state\_machine\_status](#output\_state\_machine\_status)                        | The current status of the Step Function                |
<!-- END_TF_DOCS -->
