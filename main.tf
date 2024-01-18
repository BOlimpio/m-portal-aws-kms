###################
### Primary Key ###
###################
resource "aws_kms_key" "primary_key" {
  count = !var.create_replica ? 1 : 0

  description              = var.key_description
  key_usage                = var.key_usage
  customer_master_key_spec = var.customer_master_key_spec
  is_enabled               = var.is_enabled
  enable_key_rotation      = var.enable_key_rotation
  multi_region             = var.multi_region
  deletion_window_in_days  = var.deletion_window_in_days


  tags = merge(
    {
      Name = var.key_name
    },
    var.additional_tags
  )
}

#####################
#### Replica Key ####
#####################

resource "aws_kms_replica_key" "replica_key" {
  count = var.create_replica ? 1 : 0

  deletion_window_in_days = var.deletion_window_in_days
  description             = var.key_description
  primary_key_arn         = var.primary_key_arn
  enabled                 = var.is_enabled_replica

  tags = merge(
    {
      Name = var.key_name
    },
    var.additional_tags
  )
}


###################
### General Key ###
###################

resource "aws_kms_alias" "key_alias" {
  target_key_id = try(aws_kms_key.primary_key[0].arn, aws_kms_replica_key.replica_key[0].arn)
  name          = "alias/${var.key_name}"
}

resource "aws_kms_key_policy" "key_policy" {
  key_id = try(aws_kms_key.primary_key[0].key_id, aws_kms_replica_key.replica_key[0].key_id)
  policy = data.aws_iam_policy_document.key_policy.json
}