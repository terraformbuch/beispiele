terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "terraform" {
  name     = "terraform-resources"
  location = "West Europe"
}

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

resource "azurerm_network_security_group" "terraform" {
  name                = "terraform-security-group"
  location            = azurerm_resource_group.terraform.location
  resource_group_name = azurerm_resource_group.terraform.name
}

resource "azurerm_network_security_rule" "terraform" {
  name                        = "terraform-security-rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.terraform.name
  network_security_group_name = azurerm_network_security_group.terraform.name
}

resource "azurerm_public_ip" "terraform" {
  name                = "terrafrom-public-ip"
  resource_group_name = azurerm_resource_group.terraform.name
  location            = azurerm_resource_group.terraform.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "terraform" {
  name                = "terraform-nic"
  location            = azurerm_resource_group.terraform.location
  resource_group_name = azurerm_resource_group.terraform.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.terraform.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.terraform.id
  }
}

resource "azurerm_network_interface_security_group_association" "terraform" {
  network_interface_id      = azurerm_network_interface.terraform.id
  network_security_group_id = azurerm_network_security_group.terraform.id
}

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

output "Public_IP_der_VM" {
  value = azurerm_public_ip.terraform.ip_address
}
