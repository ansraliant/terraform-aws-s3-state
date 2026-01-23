output "dynamodb_table_arn" {
  value = var.dynamodb_table == null ? null : one(aws_dynamodb_table.lock).arn
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.this.arn
}

output "s3_bucket_state_keys" {
  value = { for k, v in local.states : k => v.key }
}
