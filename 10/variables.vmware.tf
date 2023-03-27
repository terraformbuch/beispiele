variable "vmware_user" {
  default = "admin"
}

variable "vmware_password" {
  default = "admin123"
}

variable "vmware_server" {
  default = "localhost"
}

variable "vmware_datacenter" {
  default = "dc1"
}

variable "vmware_cluster" {
  default = "cluster1"
}

variable "vmware_resource_pool" {
  default = "resource-pool-1"
}

variable "vmware_host" {
  default = "esxi1"
}

variable "vmware_datastore" {
  default = "datastore1"
}

variable "vmware_network" {
  default = "VM Network"
}

variable "vmware_ipaddress" {
  default = "192.168.122.222"
}

variable "vmware_ipcidr" {
  default = "/24"
}

variable "vmware_ipgateway" {
  default = "192.168.122.1"
}
