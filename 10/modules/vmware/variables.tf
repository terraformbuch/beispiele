variable "enabled" {
  description = "Enable VMware deployment"
  type        = bool
}

variable "name" {
  description = "How to name everything."
  type        = string
}

variable "user_data" {
  description = "cloud-init user_data to pass to instance."
}

variable "admin_user" {
  description = "User to use for ssh/ansible."
  type        = string
}

variable "public_key" {
  description = "Path to SSH public key to use for ssh/ansible."
  type        = string
}

variable "private_key" {
  description = "Path to SSH private key to use for ssh/ansible. This key will never be transfered."
  type        = string
}

variable "datacenter" {
  default = "dc1"
}

variable "datastore" {
  default = "datastore1"
}

variable "cluster" {
  default = "cluster1"
}

variable "resource_pool" {
  default = "resource-pool-1"
}

variable "host" {
  default = "esxi1"
}

variable "os_image_base_url" {
  description = "Url where to get OS image."
  type        = string
  # leap's cloud-init does not start
  #default     = "http://download.opensuse.org/distribution/leap/15.3/appliances"
  default = "https://cloud-images.ubuntu.com/releases/22.04/release"
}

variable "os_image" {
  description = "Name of the OS image."
  type        = string
  # leap's cloud-init does not start
  #default = "openSUSE-Leap-15.3-JeOS.x86_64-OpenStack-Cloud.qcow2"
  default = "ubuntu-22.04-server-cloudimg-amd64.vmdk"
}

variable "network" {
  description = "Name of the network to use"
}

variable "ipaddress" {
  description = "IP address to use for the webserver"
  default     = "192.168.122.222"
}

variable "ipcidr" {
  description = "CIDR mask to use for the webserver"
  default     = "/24"
}

variable "ipgateway" {
  description = "gateway to use for the webserver"
  default     = "192.168.122.1"
}
#
#variable "cpu_amount" {
#  description = "Amount of CPU cores for the VM"
#  type        = number
#}
#
#variable "ram_amount" {
#  description = "Amount of Memory in megabytes for the VM"
#  type        = number
#}
#
#variable "guest_id" {
#  # https://developer.vmware.com/apis/358/doc/vim.vm.GuestOsDescriptor.GuestOsIdentifier.html
#  description = "Type of the guest system"
#  type        = string
#}
#
#variable "disk_size" {
#  description = "Disk size in gigabyte"
#  type        = number
#}
#
#variable "datastore_image" {
#  description = "Datastore that holds the image"
#}
#
#variable "boot_image_file" {
#  description = "path to the vm image"
#}
