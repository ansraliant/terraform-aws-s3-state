locals {
  states = { for state, file in var.states :
    state => {
      key  = "${state}/terraform.tfstate"
      file = file
    }
  }
}

data "aws_region" "this" {}

resource "local_file" "backend_config" {
  for_each = local.states

  filename        = each.value.file
  file_permission = "0664"

  content = jsonencode({
    terraform = {
      backend = {
        s3 = {
          profile = var.profile
          region  = data.aws_region.this.name

          bucket = var.bucket_name
          key    = each.value.key

          dynamodb_table = var.dynamodb_table

          encrypt = true
        }
      }
    }
  })
}
