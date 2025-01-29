resource "random_string" "bucket_suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "aws_s3_bucket" "this" {
  bucket = "${var.environment.unique_name}-${var.instance_name}-${random_string.bucket_suffix.result}"
  acl    = lookup(var.instance.spec, "acl", "private")

  versioning {
    enabled = lookup(var.instance.spec, "versioning", false)
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = lookup(var.instance.spec, "sse_algorithm", "AES256")
      }
      bucket_key_enabled = false
    }
  }
}

