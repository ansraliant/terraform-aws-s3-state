variable "profile" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "dynamodb_table" {
  type = string
}

variable "states" {
  type = map(string)
}
