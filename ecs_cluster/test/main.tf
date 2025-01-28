provider "aws" {
  profile = "facetsnew"
  region  = "us-east-1"
}

module "ecs_cluster" {
  source = "../"

  instance      = jsondecode(file("${path.module}/test.json"))
  instance_name = "test-cluster"
  environment = {
    name        = "test"
    unique_name = "project_test"
  }
  inputs = {}
}
