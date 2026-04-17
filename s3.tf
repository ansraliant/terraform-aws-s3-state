resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid    = "EnforcedTLS"
    effect = "Deny"

    actions = ["s3:*"]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.this.bucket}",
      "arn:aws:s3:::${aws_s3_bucket.this.bucket}/*",
    ]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "state_cleanup" {
  count = var.lifecycle_config != null ? 1 : 0

  bucket = aws_s3_bucket.this.id

  rule {
    id     = var.lifecycle_config.name
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days           = var.lifecycle_config.noncurrent_days
      newer_noncurrent_versions = var.lifecycle_config.newer_noncurrent_versions
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = var.lifecycle_config.abort_multipart_days
    }

    expiration {
      expired_object_delete_marker = true
    }
  }
}
