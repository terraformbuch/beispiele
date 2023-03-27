resource "azurerm_virtual_network" "terraform" {
  name                = "terraform-network"
  resource_group_name = azurerm_resource_group.terraform.name
  location            = azurerm_resource_group.terraform.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "terraform" {
  name                 = "terraform-subnet"
  resource_group_name  = azurerm_resource_group.terraform.name
  virtual_network_name = azurerm_virtual_network.terraform.name
  address_prefixes     = ["10.0.2.0/24"]
}
