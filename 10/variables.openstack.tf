variable "openstack_external_network_name" {
  description = "Name of existing external network"
}

variable "openstack_floatingip_pool" {
  description = "Name of existing floating-IP pool."
}

variable "openstack_region_net" {
  description = "Name of existing region to deploy network resources."
}

variable "openstack_region_compute" {
  description = "Name of existing region to deploy compute resources."
}

variable "openstack_os_image" {
  description = "Name of the OS image."
  type        = string
  default     = "openSUSE Leap 15.3"
}

variable "openstack_os_size" {
  description = "Name of the openstack flavor."
  type        = string
  default     = "2C-2GB-10GB"
}
