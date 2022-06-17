locals {
  name = format("%s-%s-%s", var.prefix, var.environment, var.name)

  tags = merge(
    {
      "Environment" = var.environment,
      "Terraform"   = "true"
    },
    var.tags
  )
}

/* -------------------------------------------------------------------------- */
/*                            CloudWatch Log Group                            */
/* -------------------------------------------------------------------------- */
resource "aws_cloudwatch_log_group" "this" {
  count = var.is_create_cloudwatch_log_group ? 1 : 0

  name              = format("/aws/vendedlogs/states/%s-log-group", local.name)
  retention_in_days = var.retention_in_days
  kms_key_id        = null

  tags = merge(local.tags, { "Name" = format("/aws/vendedlogs/states/%s-log-group", local.name) })
}
