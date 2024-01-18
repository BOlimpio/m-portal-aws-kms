variable "key_name" {
  type        = string
  description = "The name of the KMS key."
}

variable "key_description" {
  type        = string
  description = "The description of the KMS key."
  default = ""
}

variable "key_usage" {
  type        = string
  description = "Specifies the intended use of the KMS key. Valid values: ENCRYPT_DECRYPT or SIGN_VERIFY."
  default     = "ENCRYPT_DECRYPT"
}

variable "customer_master_key_spec" {
  type        = string
  description = "Specifies whether the KMS key is a standard key or a FIPS-compliant key. Valid values: SYMMETRIC_DEFAULT or RSA_3072."
  default     = "SYMMETRIC_DEFAULT"
}

variable "is_enabled" {
  type        = bool
  description = "Specifies whether the KMS key is enabled."
  default     = true
}

variable "enable_key_rotation" {
  type        = bool
  description = "Specifies whether key rotation is enabled."
  default     = false
}

variable "multi_region" {
  type        = bool
  description = "Specifies whether the KMS key can be replicated into different regions."
  default     = false
}

variable "additional_tags" {
  type        = map(string)
  description = "A map of default tags to apply to the KMS key."
  default     = {}
}

variable "deletion_window_in_days" {
  type        = number
  description = "The number of days in the key deletion period. Must be between 7 and 30 days."
  default     = 30

  validation {
    condition     = var.deletion_window_in_days >= 7 && var.deletion_window_in_days <= 30
    error_message = "deletion_window_in_days must be between 7 and 30 days."
  }
}

#######################
## Replica variables ##
#######################

variable "create_replica" {
  type        = bool
  description = "If true, create a replicated KMS key."
  default     = false
}

variable "is_enabled_replica" {
  type        = bool
  description = "If true, the replicated KMS key will be enabled."
  default     = true
}

variable "primary_key_arn" {
  description = "The ARN of the primary key. Provide this when creating a replica."
  type        = string
  default     = null
}

######################
## Policy variables ##
######################

variable "enable_default_policy" {
  type        = bool
  description = "Enable the default policy allowing account-wide access to all key operations."
  default     = true
}

variable "key_administrators" {
  type        = list(string)
  description = "List of AWS principals who are key administrators."
  default     = []
}

variable "key_users" {
  type        = list(string)
  description = "List of AWS principals who are key users."
  default     = []
}

variable "custom_iam_policy_statement" {
  type        = string
  description = "Custom policy statements."
  default     = ""
}