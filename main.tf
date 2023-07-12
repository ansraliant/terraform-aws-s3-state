data "aws_region" "this" {}

resource "local_file" "backend_config" {
  for_each = var.states

  filename        = each.value
  file_permission = "0664"

  content = jsonencode({
    terraform = {
      backend = {
        s3 = {
          profile = var.profile
          region  = data.aws_region.this.name

          bucket = var.bucket_name
          key    = "${each.key}/terraform.tfstate"

          dynamodb_table = var.dynamodb_table

          encrypt = true
        }
      }
    }
  })
}
