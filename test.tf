# ##################
# ### Key policy ###
# ##################

# data "aws_iam_policy_document" "kms_primary_key_policy" {
#   source_policy_documents = compact([
#       var.custom_iam_policy_statement,
#       var.enable_default_policy ? data.aws_iam_policy_document.default[0].json : "",
#       length(var.key_users) > 0 ? data.aws_iam_policy_document.common_usage[0].json : "",
#       length(var.key_administrators) > 0 ? data.aws_iam_policy_document.key_administration[0].json : "",
#     ]
#   )
# }

# data "aws_iam_policy_document" "default" {
#   count = var.enable_default_policy ? 1 : 0

#   statement {
#     sid       = "Default"
#     actions   = ["kms:*"]
#     resources = [try(aws_kms_key.primary_key[0].arn, aws_kms_replica_key.replica_key[0].arn)]

#     principals {
#       type        = "AWS"
#       identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
#     }
#   }
# }

# data "aws_iam_policy_document" "common_usage" {
#   count = length(var.key_users) > 0 ? 1 : 0

#   statement {
#     sid = "KeyUsage"
#     actions = [
#       "kms:Encrypt",
#       "kms:Decrypt",
#       "kms:ReEncrypt*",
#       "kms:GenerateDataKey*",
#       "kms:DescribeKey",
#     ]
#     resources = [try(aws_kms_key.primary_key[0].arn, aws_kms_replica_key.replica_key[0].arn)]

#     principals {
#       type        = "AWS"
#       identifiers = var.key_users
#     }
#   }
# }

# data "aws_iam_policy_document" "key_administration" {
#   count = length(var.key_administrators) > 0 ? 1 : 0

#   statement {
#     sid = "KeyAdministration"
#     actions = [
#       "kms:Create*",
#       "kms:Describe*",
#       "kms:Enable*",
#       "kms:List*",
#       "kms:Put*",
#       "kms:Update*",
#       "kms:Revoke*",
#       "kms:Disable*",
#       "kms:Get*",
#       "kms:Delete*",
#       "kms:TagResource",
#       "kms:UntagResource",
#       "kms:ScheduleKeyDeletion",
#       "kms:CancelKeyDeletion",
#       "kms:ReplicateKey",
#       "kms:ImportKeyMaterial"
#     ]
#     resources = [try(aws_kms_key.primary_key[0].arn, aws_kms_replica_key.replica_key[0].arn)]

#     principals {
#       type        = "AWS"
#       identifiers = var.key_administrators
#     }
#   }
# }