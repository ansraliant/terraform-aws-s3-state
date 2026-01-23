# Terraform Remote State Config Module

This module creates a bucket to hold the state files of Terraform/OpenTofu and automatically generates backend configuration files. Optionally, it can also create a DynamoDB table for state locking for compatibility with older versions of Terraform/OpenTofu.

## How to Use

See [variables.tf](variables.tf) for all configuration options.

You will need a `main.tf` to call this module with the correct parameters.

### Simple Example

```HCL
provider "aws" {
  region = "ap-northeast-1"
}

module "s3_state" {
  source = "ansraliant/s3-state/aws"

  bucket_name    = "mybucket"
  states         = { infra = "../backend.tf.json" }
}
```

### Advanced Example

```HCL
locals {
  prefix  = "myproject"
  profile = "my-aws-profile"
  region  = "ap-northeast-1"

  states = {
    infra = "../backend.tf.json"
    auth  = "../auth/backend.tf.json"
  }

  bucket_name    = "${local.prefix}-${substr(md5(data.aws_caller_identity.this.account_id), 0, 16)}"
}

data "aws_caller_identity" "this" {}

provider "aws" {
  profile = local.profile
  region  = local.region
}

module "s3_state" {
  source  = "ansraliant/s3-state/aws"

  profile        = local.profile
  bucket_name    = local.bucket_name
  states         = local.states
}
```
