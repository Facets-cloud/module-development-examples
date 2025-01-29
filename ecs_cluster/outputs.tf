locals {
  output_interfaces = {}
  output_attributes = {
    cluster_arn = aws_ecs_cluster.this.arn
  }
}
