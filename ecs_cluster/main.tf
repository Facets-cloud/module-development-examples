resource "aws_ecs_cluster" "this" {
  name = "${var.environment.unique_name}-${var.instance_name}"

  capacity_providers = ["FARGATE"]
}

locals {
  output_interfaces = {}
  output_attributes = {
    cluster_arn = aws_ecs_cluster.this.arn
  }
}
