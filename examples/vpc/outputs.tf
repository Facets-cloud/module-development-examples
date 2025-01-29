locals {
  output_interfaces = {}
  output_attributes = {
    subnet_ids = aws_subnet.this[*].id
  }
}
