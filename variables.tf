variable "profile" {
  type = string

  default = "default"
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
