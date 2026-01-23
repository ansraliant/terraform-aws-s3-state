variable "profile" {
  type = string

  default = null

  description = "While optional it is recommented to specify the AWS profile to avoid accidentally deploying to the wrong account."
}

variable "bucket_name" {
  type = string
}

variable "states" {
  type = map(string)
}

variable "use_s3_native_locking" {
  type = bool

  default = true

  description = "Use S3-native state locking. This requires Terraform/OpenTofu 1.10.0 or later. If set to false, Terraform/OpenTofu default will be used."
}

variable "dynamodb_table" {
  type = string

  default = null

  description = "Use DynamoDB table for state locking. This is useful only for compatibility with Terraform/OpenTofu prior to 1.10.0."
}
