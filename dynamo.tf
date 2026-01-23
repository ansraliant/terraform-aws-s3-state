resource "aws_dynamodb_table" "lock" {
  count = var.dynamodb_table == null ? 0 : 1

  name         = var.dynamodb_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S" # String
  }
}
