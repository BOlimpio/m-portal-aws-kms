module "kms_primary_key" {
  source = "github.com/BOlimpio/m-portal-aws-kms?ref=v1.0.0"

  key_name              = "cloudymos_primary_key"
  key_description       = "Example KMS Key"
  key_usage             = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  is_enabled            = true
  enable_key_rotation   = true
  multi_region          = true
  deletion_window_in_days = 7
  custom_iam_policy_statement = data.aws_iam_policy_document.custom_primary_key_policy.json
  
  # Default policy to grant admin access too root account
  enable_default_policy = true

  key_administrators    = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/bruno-olimpio"
    ]
  key_users             = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/bruno-olimpio"
    ]

  additional_tags       = {
    Environment = "Production"
  }
}

# # Data source for key policy
data "aws_iam_policy_document" "custom_primary_key_policy" {
  statement {
    sid       = "AllowCloudymosUserKeyRotation"
    effect    = "Allow"
    actions   = [
      "kms:EnableKeyRotation", 
      "kms:DisableKeyRotation"
      ]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/cloudymos"]
    }
  }
} 

####################### Replica Key #######################

module "kms_replica_key" {
  source = "github.com/BOlimpio/m-portal-aws-kms"

  providers = {
    aws = aws.replica
  }

  create_replica = true
  key_name              = "cloudymos_replica_key"
  key_description       = "Example KMS Replica Key"
  is_enabled_replica            = true
  deletion_window_in_days = 7
  custom_iam_policy_statement = data.aws_iam_policy_document.custom_primary_key_policy.json
  primary_key_arn = module.kms_primary_key.kms_key["arn"]
  
  # Default policy to grant admin access too root account
  enable_default_policy = true

  key_administrators    = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/bruno-olimpio"
    ]
  key_users             = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/bruno-olimpio"
    ]

  additional_tags       = {
    Environment = "Production"
  }
}