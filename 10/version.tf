terraform {
  required_version = ">= 1.3.6"
}

provider "aws" {
  region = var.aws_region
}

# Configure the Azure Provider
provider "azurerm" {
  features {}
}

provider "google" {
  project     = var.gcp_project
  credentials = file(var.gcp_credentials)
  region      = var.gcp_region
  zone        = "${var.gcp_region}-b"
}

# load_balancer module uses beta provider
provider "google-beta" {
  project     = var.gcp_project
  credentials = file(var.gcp_credentials)
  region      = var.gcp_region
  zone        = "${var.gcp_region}-b"
}

# libvirt provider must be configured inside module
#provider "libvirt" {
#  uri = var.qemu_uri
#}

# empty provider does not need to be configured
#provider "openstack" {}

provider "vsphere" {
  ## can also be configured via environment variables
  # user           = var.vmware_user
  # password       = var.vmware_password
  # vsphere_server = var.vmware_server

  # # If you have a self-signed cert
  # allow_unverified_ssl = true

  # avoid 403 errors
  persist_session = true
}
