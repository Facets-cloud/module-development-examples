locals {
  output_interfaces = {
    for idx in range(length(aws_instance.vm)) : "vm${idx + 1}" => {
      public_ip          = aws_instance.vm[idx].public_ip
      private_ip  = aws_instance.vm[idx].private_ip
      private_key = base64encode(tls_private_key.ssh_key.private_key_pem)
      public_key  = tls_private_key.ssh_key.public_key_openssh
      username    = "ubuntu"
      secrets     = ["private_key", "public_key"]
    }
  }
  output_attributes = {}
}
