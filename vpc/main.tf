resource "aws_vpc" "this" {
  cidr_block = var.instance.spec.cidr
}

resource "aws_subnet" "this" {
  count             = 1
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.instance.spec.cidr, 8, count.index)
}

locals {
  output_interfaces = {}
  output_attributes = {
    subnet_ids = aws_subnet.this[*].id
  }
}
