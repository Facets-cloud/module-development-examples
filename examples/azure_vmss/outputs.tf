locals {
  output_interfaces = {}
  output_attributes = {
    vmss_id = azurerm_linux_virtual_machine_scale_set.this.id
    private_key   = tls_private_key.ssh_key.private_key_pem
    public_key    = tls_private_key.ssh_key.public_key_openssh
    secrets       = ["private_key"]
  }
}
