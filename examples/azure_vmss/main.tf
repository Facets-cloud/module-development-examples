resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_linux_virtual_machine_scale_set" "this" {
  admin_username = "vmadmin"
  admin_ssh_key {
    username   = "vmadmin"
    public_key = tls_private_key.ssh_key.public_key_openssh
  }
  name                = "${var.environment.unique_name}-${var.instance_name}"
  location            = var.inputs["azure_vnet_details"].attributes["location"]
  sku                 = var.instance.spec.vm_size
  instances           = var.instance.spec.instance_count
  resource_group_name = var.inputs["azure_vnet_details"].attributes["resource_group_name"]

  network_interface {
    name    = "${var.environment.unique_name}-${var.instance_name}-nic"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = var.inputs["azure_vnet_details"].attributes["subnet_id"]

      public_ip_address {
        name = "public"
      }
    }
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
