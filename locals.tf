locals {
  name = format("%s-%s-%s", var.prefix, var.environment, var.name)

  role_arn = var.is_create_role ? aws_iam_role.this[0].arn : var.exists_role_arn

  enable_xray_tracing = try(var.service_integrations["xray"]["xray"], false) == true

  tags = merge(
    {
      "Environment" = var.environment,
      "Terraform"   = "true"
    },
    var.tags
  )
}
