terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = ">= 1.44"
    }
    template = {
      source = "hashicorp/template"
    }
  }
  required_version = ">= 1.3.0"
}
