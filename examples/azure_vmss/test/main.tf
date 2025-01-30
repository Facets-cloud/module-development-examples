provider "azurerm" {
  features {}
}

module "azure_vmss" {
  source = "../"

  instance      = jsondecode(file("${path.module}/test.json"))
  instance_name = "test-vmss"
  environment = {
    name                = "test"
    unique_name         = "project_test"
    location            = "East US"
    resource_group_name = "test-rg"
  }
  inputs = {
    azure_vnet_details = {
      attributes = {
        subnet_id = module.azure_vnet.output_attributes.subnet_id
        resource_group_name = module.azure_vnet.output_attributes.resource_group_name
      }
    }
  }
}
