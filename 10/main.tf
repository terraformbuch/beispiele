locals {
  cloudinit_user_data = templatefile("${path.root}/cloud_init.yml", {
    hostname      = var.name,
    public_key    = file(var.public_key),
    admin_user    = var.admin_user,
    root_password = random_password.root_password.result
  })
  cloudinit_user_data_vmware = templatefile("${path.root}/cloud_init_vmware.yml", {
    hostname      = var.name,
    public_key    = file(var.public_key),
    admin_user    = var.admin_user,
    root_password = random_password.root_password.result
    ipaddress     = var.vmware_ipaddress
    ipcidr        = var.vmware_ipcidr
    ipgateway     = var.vmware_ipgateway
  })
}

# random root password set by cloud-init
resource "random_password" "root_password" {
  length      = 16
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
  special     = false
}

module "libvirt" {
  # count cannot be used as providers cannot be defined in modules using count
  # count  = var.libvirt_enabled ? 1 : 0
  source = "./modules/libvirt"

  enabled     = var.libvirt_enabled
  name        = var.name
  user_data   = local.cloudinit_user_data
  admin_user  = var.admin_user
  public_key  = var.public_key
  private_key = var.private_key
  # provider specific
  qemu_uri      = var.libvirt_qemu_uri
  bridge_device = var.libvirt_bridge_device
  network_name  = var.libvirt_network_name
}

module "openstack" {
  # count cannot be used as providers cannot be defined in modules using count
  count  = var.openstack_enabled ? 1 : 0
  source = "./modules/openstack"

  enabled     = var.openstack_enabled
  name        = var.name
  user_data   = local.cloudinit_user_data
  admin_user  = var.admin_user
  public_key  = var.public_key
  private_key = var.private_key
  # provider specific
  external_network_name = var.openstack_external_network_name
  floatingip_pool       = var.openstack_floatingip_pool
  region_net            = var.openstack_region_net
  region_compute        = var.openstack_region_compute
  os_image              = var.openstack_os_image
  os_size               = var.openstack_os_size
}

module "azure" {
  # count cannot be used as providers cannot be defined in modules using count
  count  = var.azure_enabled ? 1 : 0
  source = "./modules/azure"

  enabled     = var.azure_enabled
  name        = var.name
  user_data   = local.cloudinit_user_data
  admin_user  = var.admin_user
  public_key  = var.public_key
  private_key = var.private_key
  # provider specific
  region             = var.azure_region
  os_image_publisher = var.azure_os_image_publisher
  os_image_offer     = var.azure_os_image_offer
  os_image_sku       = var.azure_os_image_sku
  os_image_version   = var.azure_os_image_version
  vm_size            = var.azure_vm_size
}

locals {
  gcp_project = var.gcp_project == "" ? var.name : var.gcp_project
}

module "gcp" {
  # count cannot be used as providers cannot be defined in modules using count
  count  = var.gcp_enabled ? 1 : 0
  source = "./modules/gcp"

  enabled     = var.gcp_enabled
  name        = var.name
  user_data   = local.cloudinit_user_data
  admin_user  = var.admin_user
  public_key  = var.public_key
  private_key = var.private_key
  # provider specific
  project  = var.gcp_project
  region   = var.gcp_region
  os_image = var.gcp_os_image
  vm_size  = var.gcp_vm_size
}

# Leider ist es aktuell nicht möglich den vspere Provider einfach zu deaktivieren. Daher müssen, falls das `vmware` Modul genutzt werden soll, in _main.tf_ und _outputs.tf_ einige `vmware`-Modul spezifische Zeilen einkommentiert werden.
#module "vmware" {
#  count  = var.vmware_enabled ? 1 : 0
#  source = "./modules/vmware"
#
#  enabled     = var.vmware_enabled
#  name        = var.name
#  user_data   = local.cloudinit_user_data_vmware
#  admin_user  = var.admin_user
#  public_key  = var.public_key
#  private_key = var.private_key
#  # provider specific
#  datacenter = var.vmware_datacenter
#  cluster    = var.vmware_cluster
#  host       = var.vmware_host
#  datastore  = var.vmware_datastore
#  network    = var.vmware_network
#  ipaddress  = var.vmware_ipaddress
#  ipcidr     = var.vmware_ipcidr
#  ipgateway  = var.vmware_ipgateway
#}

module "aws" {
  count  = var.aws_enabled ? 1 : 0
  source = "./modules/aws"

  enabled     = var.aws_enabled
  name        = var.name
  user_data   = local.cloudinit_user_data
  admin_user  = var.admin_user
  public_key  = var.public_key
  private_key = var.private_key
  # provider specific
  azs      = var.aws_azs
  os_image = var.aws_os_image
  os_size  = var.aws_os_size
}
