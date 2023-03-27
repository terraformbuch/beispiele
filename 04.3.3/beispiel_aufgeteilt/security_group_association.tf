resource "azurerm_network_interface_security_group_association" "terraform" {
  network_interface_id      = azurerm_network_interface.terraform.id
  network_security_group_id = azurerm_network_security_group.terraform.id
}
