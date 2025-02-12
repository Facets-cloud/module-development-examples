locals {
  test = true
}

resource "aws_ecs_cluster" "this" {
  name = "${var.environment.unique_name}-${var.instance_name}"

  capacity_providers = ["FARGATE"]
}

