output "kms_key" {
  description = "A map of all kms key attributes"
  value       = try(aws_kms_key.primary_key[0], aws_kms_replica_key.replica_key[0])
}

output "key_alias" {
  description = "A map of alias attributes"
  value       = aws_kms_alias.key_alias
}