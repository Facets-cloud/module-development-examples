provider "azurerm" {
  features {}
}

module "azure_vnet" {
  source = "../"

  instance      = jsondecode(file("${path.module}/test.json"))
  instance_name = "test-vnet"
  environment = {
    name                = "test"
    unique_name         = "project_test"
    location            = "East US"
    resource_group_name = "test-rg"
  }
  inputs = {}
}
