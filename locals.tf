locals {
  account_id = try(data.aws_caller_identity.current.account_id, "")
  partition  = try(data.aws_partition.current.partition, "")
}