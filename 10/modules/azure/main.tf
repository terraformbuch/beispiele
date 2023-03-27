locals {
  azure_ip              = azurerm_network_interface.webserver.ip_configuration.0.private_ip_address
  azure_ip_bastion      = azurerm_public_ip.bastion.ip_address
  azure_ip_loadbalancer = azurerm_public_ip.webserver.ip_address
  azure_ansible_trigger = azurerm_virtual_machine.webserver.id
  resource_group_name   = azurerm_resource_group.rg.name
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.name}-rg"
  location = var.region
}

resource "random_id" "diag" {
  byte_length = 2
}

resource "azurerm_storage_account" "diag" {
  name                     = "${var.name}diag${lower(random_id.diag.hex)}"
  resource_group_name      = local.resource_group_name
  location                 = var.region
  account_replication_type = "LRS"
  account_tier             = "Standard"
}

resource "azurerm_virtual_network" "net" {
  name                = "${var.name}-net"
  address_space       = [var.iprange-net-internal]
  location            = var.region
  resource_group_name = local.resource_group_name
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.name}-subnet"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.net.name
  address_prefixes     = [var.iprange-subnet-internal]
}

resource "azurerm_subnet_network_security_group_association" "webserver" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.webserver.id
}

resource "azurerm_subnet_route_table_association" "subnet" {
  subnet_id      = azurerm_subnet.subnet.id
  route_table_id = azurerm_route_table.routes.id
}

resource "azurerm_route_table" "routes" {
  name                = "${var.name}-routes"
  location            = var.region
  resource_group_name = local.resource_group_name

  route {
    name           = "default"
    address_prefix = var.iprange-net-internal
    next_hop_type  = "VnetLocal"
  }
}

resource "azurerm_network_security_group" "webserver" {
  name                = "${var.name}-secgroup"
  location            = var.region
  resource_group_name = local.resource_group_name
  security_rule {
    name                       = "OUTALL"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "LOCAL"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = var.iprange-net-internal
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 103
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 104
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "bastion" {
  name                    = "${var.name}-bastion-pip"
  location                = var.region
  resource_group_name     = local.resource_group_name
  allocation_method       = "Static"
  idle_timeout_in_minutes = 30
}

resource "azurerm_public_ip" "webserver" {
  name                    = "${var.name}-pip"
  location                = var.region
  resource_group_name     = local.resource_group_name
  allocation_method       = "Static"
  idle_timeout_in_minutes = 30
}

resource "azurerm_network_interface" "bastion" {
  name                          = "${var.name}-bastion-nic"
  location                      = var.region
  resource_group_name           = local.resource_group_name
  enable_accelerated_networking = false

  ip_configuration {
    name                          = "ipconf-primary"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.ipaddress-bastion-internal
    public_ip_address_id          = azurerm_public_ip.bastion.id
  }
}

resource "azurerm_network_interface" "webserver" {
  name                          = "${var.name}-nic"
  location                      = var.region
  resource_group_name           = local.resource_group_name
  enable_accelerated_networking = false

  ip_configuration {
    name                          = "ipconf-primary"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.ipaddress-internal
  }
}

resource "azurerm_lb" "webserver" {
  name                = "${var.name}-lb"
  location            = var.region
  resource_group_name = local.resource_group_name

  frontend_ip_configuration {
    name                 = "${var.name}-pib"
    public_ip_address_id = azurerm_public_ip.webserver.id
  }
}

resource "azurerm_lb_backend_address_pool" "webserver" {
  loadbalancer_id = azurerm_lb.webserver.id
  name            = var.name
}

resource "azurerm_network_interface_backend_address_pool_association" "webserver" {
  network_interface_id    = azurerm_network_interface.webserver.id
  ip_configuration_name   = "ipconf-primary"
  backend_address_pool_id = azurerm_lb_backend_address_pool.webserver.id
}

resource "azurerm_lb_probe" "webserver" {
  loadbalancer_id     = azurerm_lb.webserver.id
  name                = var.name
  protocol            = "Http"
  request_path        = "/"
  port                = 80
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb_rule" "webserver_http" {
  loadbalancer_id                = azurerm_lb.webserver.id
  name                           = "${var.name}-http"
  protocol                       = "Tcp"
  frontend_ip_configuration_name = "${var.name}-pib"
  frontend_port                  = 80
  backend_port                   = 80
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.webserver.id]
  probe_id                       = azurerm_lb_probe.webserver.id
  idle_timeout_in_minutes        = 30
  enable_floating_ip             = "false"
}

# resource "azurerm_lb_rule" "webserver_https" {
#   resource_group_name            = local.resource_group_name
#   loadbalancer_id                = azurerm_lb.webserver.id
#   name                           = "${var.name}-https"
#   protocol                       = "Tcp"
#   frontend_ip_configuration_name = "${var.name}-pib"
#   frontend_port                  = 443
#   backend_port                   = 443
#   backend_address_pool_ids       = [azurerm_lb_backend_address_pool.webserver.id]
#   probe_id                       = azurerm_lb_probe.webserver.id
#   idle_timeout_in_minutes        = 30
#   enable_floating_ip             = "true"
# }

resource "random_password" "admin_password" {
  length      = 16
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
  special     = false
}

resource "azurerm_virtual_machine" "bastion" {
  name                             = "${var.name}-bastion"
  location                         = var.region
  resource_group_name              = local.resource_group_name
  network_interface_ids            = [azurerm_network_interface.bastion.id]
  vm_size                          = var.vm_size
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_os_disk {
    name              = "${var.name}-bastion-os"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  # az vm image list --output table --publisher SUSE --all
  storage_image_reference {
    publisher = var.os_image_publisher
    offer     = var.os_image_offer
    sku       = var.os_image_sku
    version   = var.os_image_version
  }

  os_profile {
    computer_name  = "${var.name}-bastion"
    admin_username = var.admin_user
    admin_password = random_password.admin_password.result
    # cloud-init
    custom_data = var.user_data
  }

  os_profile_linux_config {
    disable_password_authentication = false

    ## is configured via cloud-init
    # ssh_keys {
    #   path     = "/home/${var.admin_user}/.ssh/authorized_keys"
    #   key_data = var.public_key
    # }
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = azurerm_storage_account.diag.primary_blob_endpoint
  }

}

resource "azurerm_virtual_machine" "webserver" {
  name                             = var.name
  location                         = var.region
  resource_group_name              = local.resource_group_name
  network_interface_ids            = [azurerm_network_interface.webserver.id]
  vm_size                          = var.vm_size
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_os_disk {
    name              = "${var.name}-os"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  # az vm image list --output table --publisher SUSE --all
  storage_image_reference {
    publisher = var.os_image_publisher
    offer     = var.os_image_offer
    sku       = var.os_image_sku
    version   = var.os_image_version
  }

  os_profile {
    computer_name  = var.name
    admin_username = var.admin_user
    admin_password = random_password.admin_password.result
    # cloud-init
    custom_data = var.user_data
  }

  os_profile_linux_config {
    disable_password_authentication = false

    ## is configured via cloud-init
    # ssh_keys {
    #   path     = "/home/${var.admin_user}/.ssh/authorized_keys"
    #   key_data = file(var.public_key)
    # }
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = azurerm_storage_account.diag.primary_blob_endpoint
  }

  # depends_on = [azurerm_virtual_machine.bastion, azurerm_public_ip.bastion]

}

resource "null_resource" "azure_ansible" {
  triggers = {
    id = local.azure_ansible_trigger
  }

  connection {
    host                = local.azure_ip
    type                = "ssh"
    user                = var.admin_user
    private_key         = file(pathexpand(var.private_key))
    bastion_host        = local.azure_ip_bastion
    bastion_user        = var.admin_user
    bastion_private_key = file(pathexpand(var.private_key))
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait"
    ]
  }

  provisioner "local-exec" {
    command = <<EOL
        export ANSIBLE_HOST_KEY_CHECKING=False;
        export ANSIBLE_SSH_COMMON_ARGS='-A -i ${var.private_key} -o ProxyCommand="ssh -W %h:%p ${var.admin_user}@${local.azure_ip_bastion}"'
        until nc -zv ${local.azure_ip_bastion} 22; do sleep 10; done
        pgrep ssh-agent || eval $(ssh-agent) && ssh-add ${var.private_key}
        ansible-playbook -u ${var.admin_user} --private-key ${var.private_key} -i ${local.azure_ip}, ansible/web-playbook.yaml
      EOL
  }
}

resource "null_resource" "azure_open_url" {
  depends_on = [null_resource.azure_ansible]

  triggers = {
    id = null_resource.azure_ansible.id
  }

  provisioner "local-exec" {
    command = <<EOL
        curl http://${local.azure_ip_loadbalancer}
      EOL
  }
}
