provider "aws" {
  profile = "facetsnew"
  region = "us-east-1"
}

module "s3_bucket" {
  source = "../"

  instance      = jsondecode(file("${path.module}/test.json"))
  instance_name = "test-bucket"
  environment = {
    name        = "test"
    unique_name = "project_test"
  }
  inputs = {}
}
