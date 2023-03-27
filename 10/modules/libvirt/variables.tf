# global
variable "name" {
  description = "How to name everything."
  type        = string
}

variable "user_data" {
  description = "cloud-init user_data to pass to instance."
}

#variable "network_config" {
#  description = "cloud-init network_config to pass to instance."
#}

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

# network specific
# variable "iprange-net-internal" {
#   description = "IP range of the existing network."
#   type        = string
#   default     = "192.168.13.0/24"
#   validation {
#     condition = (
#       can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}$", var.iprange-net-internal))
#     )
#     error_message = "Invalid IP range format. It must be something like: 102.168.10.5/24 ."
#   }
# }

# network specific
# variable "iprange-subnet-internal" {
#   description = "IP range of the existing network."
#   type        = string
#   default     = "192.168.13.0/25"
#   validation {
#     condition = (
#       can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}$", var.iprange-subnet-internal))
#     )
#     error_message = "Invalid IP range format. It must be something like: 102.168.10.5/24 ."
#   }
# }

#variable "ipaddress-internal" {
#  description = "IP address in the existing the network."
#  type        = string
#  default     = "192.168.13.12"
#  validation {
#    condition = (
#      can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$", var.ipaddress-internal))
#    )
#    error_message = "Invalid IP address format. It must be something like: 102.168.10.5."
#  }
#}

# provider specific
variable "enabled" {
  description = "Enable libvirt deployment."
  type        = bool
}

variable "os_image_base_url" {
  description = "Url where to get OS image."
  type        = string
  default     = "http://download.opensuse.org/distribution/leap/15.3/appliances"
}

variable "os_image" {
  description = "Name of the OS image."
  type        = string
  # This image has cloud-init pre-installed
  default = "openSUSE-Leap-15.3-JeOS.x86_64-OpenStack-Cloud.qcow2"
}

variable "qemu_uri" {
  description = "URI to connect with the qemu-service."
  default     = "qemu:///system"
}

variable "storage_pool" {
  description = "libvirt storage pool name for VM disks"
  type        = string
  default     = "default"
}

variable "bridge_device" {
  description = "Which existing bridge device to use."
  type        = string
}

variable "network_name" {
  description = "Which existing network to use."
  type        = string
}
