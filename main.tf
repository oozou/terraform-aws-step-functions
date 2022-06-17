data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

/* -------------------------------------------------------------------------- */
/*                                  IAM Role                                  */
/* -------------------------------------------------------------------------- */
data "aws_iam_policy_document" "log_access_policy" {
  count = var.is_create_role && var.is_create_cloudwatch_log_group ? 1 : 0

  statement {
    sid = "AllowStepFunctionToUseLog"

    effect = "Allow"

    actions = [
      "logs:CreateLogDelivery",
      "logs:GetLogDelivery",
      "logs:UpdateLogDelivery",
      "logs:DeleteLogDelivery",
      "logs:ListLogDeliveries",
      "logs:PutResourcePolicy",
      "logs:DescribeResourcePolicies",
      "logs:DescribeLogGroups"
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "log_access_policy" {
  count = var.is_create_role && var.is_create_cloudwatch_log_group ? 1 : 0

  name   = format("%s-log-access-policy", local.name)
  policy = data.aws_iam_policy_document.log_access_policy[0].json

  tags = merge(local.tags, { "Name" = format("%s-log-access-policy", local.name) })
}

resource "aws_iam_role_policy_attachment" "log_acces" {
  count = var.is_create_role && var.is_create_cloudwatch_log_group ? 1 : 0

  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.log_access_policy[0].arn
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
