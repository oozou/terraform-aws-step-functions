/* -------------------------------------------------------------------------- */
/*                                   Generic                                  */
/* -------------------------------------------------------------------------- */
variable "name" {
  description = "Name of the ECS cluster to create"
  type        = string
}

variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
}

variable "prefix" {
  description = "The prefix name of customer to be displayed in AWS console and resource"
  type        = string
}

variable "tags" {
  description = "Custom tags which can be passed on to the AWS resources. They should be key value pairs having distinct keys"
  type        = map(any)
  default     = {}
}

/* -------------------------------------------------------------------------- */
/*                                  IAM Role                                  */
/* -------------------------------------------------------------------------- */
variable "is_create_role" {
  description = "Whether to create step function roles or not"
  type        = bool
  default     = true
}

variable "exists_role_arn" {
  description = "The exist role arn for step functions"
  type        = string
  default     = ""
}

variable "trusted_entities" {
  description = "Step Function additional trusted entities for assuming roles (trust relationship)"
  type        = list(string)
  default     = []
}

variable "additional_role_policy_arn" {
  description = "Map of policies ARNs to attach to the lambda"
  type        = map(string)
  default     = {}
}

/* -------------------------------------------------------------------------- */
/*                            CloudWatch Log Group                            */
/* -------------------------------------------------------------------------- */
variable "is_create_cloudwatch_log_group" {
  description = "Whether to create cloudwatch log group or not"
  type        = bool
  default     = true
}

variable "retention_in_days" {
  description = "Retention day for cloudwatch log group"
  type        = number
  default     = 30
}
