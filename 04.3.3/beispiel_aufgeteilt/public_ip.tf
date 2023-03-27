resource "azurerm_public_ip" "terraform" {
  name                = "terrafrom-public-ip"
  resource_group_name = azurerm_resource_group.terraform.name
  location            = azurerm_resource_group.terraform.location
  allocation_method   = "Static"
}
