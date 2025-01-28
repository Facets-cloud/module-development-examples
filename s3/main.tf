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
}


locals {
  output_interfaces = {}  # Define network interfaces if applicable
  output_attributes = {
    bucket_name = aws_s3_bucket.this.bucket
    arn         = aws_s3_bucket.this.arn
  }
}
