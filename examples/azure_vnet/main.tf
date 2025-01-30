resource "azurerm_resource_group" "this" {
  name     = "${var.environment.unique_name}-rg"
  location = var.instance.spec.location
}

resource "azurerm_virtual_network" "this" {
  resource_group_name = azurerm_resource_group.this.name
  name                = "${var.environment.unique_name}-${var.instance_name}"
  address_space       = [var.instance.spec.address_space]
  location            = var.instance.spec.location
}

resource "azurerm_subnet" "this" {
  name                 = "${var.environment.unique_name}-${var.instance_name}-subnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.instance.spec.subnet_prefix]
}
