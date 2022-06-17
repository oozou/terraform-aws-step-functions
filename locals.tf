locals {
  name = format("%s-%s-%s", var.prefix, var.environment, var.name)

  enable_xray_tracing = try(var.service_integrations["xray"]["xray"], false) == true

  tags = merge(
    {
      "Environment" = var.environment,
      "Terraform"   = "true"
    },
    var.tags
  )
}
