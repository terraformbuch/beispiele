resource "azurerm_linux_virtual_machine" "terraform" {
  name                = "terraform-machine"
  resource_group_name = azurerm_resource_group.terraform.name
  location            = azurerm_resource_group.terraform.location

  size = "Standard_F2"

  admin_username = "adminuser"
  admin_ssh_key {
    username   = "adminuser"
    public_key = file(pathexpand("~/.ssh/id_rsa.pub"))
  }

  network_interface_ids = [
    azurerm_network_interface.terraform.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "SUSE"
    offer     = "opensuse-leap-15-4"
    sku       = "gen1"
    version   = "latest"
  }
}
