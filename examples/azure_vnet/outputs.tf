locals {
  output_interfaces = {}
  output_attributes = {
    vnet_id     = azurerm_virtual_network.this.id
    subnet_id   = azurerm_subnet.this.id
    resource_group_name = azurerm_resource_group.this.name
    location = azurerm_resource_group.this.location
  }
}
