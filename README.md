# Terraform Remote State Config Module

This module creates a bucket to hold the remote state files of terraform, a dynamo db table for the locks and automatically generates backend configuration files.

## How to Use
You will need a `main.tf` to call this module with the correct parameters.
Example:

```HCL
locals {
  prefix  = "myproject"
  profile = "default"
  region  = "ap-northeast-1"

  states = {
    infra = "../backend.tf.json"
    auth  = "../auth/backend.tf.json"
  }

  bucket_name    = "${local.prefix}-${substr(md5(data.aws_caller_identity.this.account_id), 0, 16)}"
  dynamodb_table = local.prefix
}

data "aws_caller_identity" "this" {}

provider "aws" {
  profile = local.profile
  region  = local.region
}

module "remote_state" {
  source  = "ansraliant/s3-state/aws"

  profile        = local.profile
  bucket_name    = local.bucket_name
  dynamodb_table = local.dynamodb_table
  states         = local.states
}
```

You can either hardcode, use tfvars, whatever works for you
