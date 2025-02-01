provider "aws" {
  region = "us-east-1"
}

module "aws_vm_module" {
  source = "../"

  instance      = jsondecode(file("${path.module}/test.json"))
  instance_name = "example-instance"
  environment = {
    name        = "development"
    unique_name = "dev_project"
  }
  inputs = {}
}
