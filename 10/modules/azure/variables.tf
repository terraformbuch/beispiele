# global
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

# network specific
variable "iprange-net-internal" {
  description = "IP range of the network to create."
  type        = string
  default     = "192.168.13.0/24"
  validation {
    condition = (
      can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}$", var.iprange-net-internal))
    )
    error_message = "Invalid IP range format. It must be something like: 102.168.10.5/24 ."
  }
}
variable "iprange-subnet-internal" {
  description = "IP range of the network to create."
  type        = string
  default     = "192.168.13.0/25"
  validation {
    condition = (
      can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}$", var.iprange-subnet-internal))
    )
    error_message = "Invalid IP range format. It must be something like: 102.168.10.5/24 ."
  }
}

variable "ipaddress-bastion-internal" {
  description = "IP address in the existing the network."
  type        = string
  default     = "192.168.13.10"
  validation {
    condition = (
      can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$", var.ipaddress-bastion-internal))
    )
    error_message = "Invalid IP address format. It must be something like: 102.168.10.5."
  }
}

variable "ipaddress-loadbalancer-internal" {
  description = "IP address in the existing the network."
  type        = string
  default     = "192.168.13.11"
  validation {
    condition = (
      can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$", var.ipaddress-loadbalancer-internal))
    )
    error_message = "Invalid IP address format. It must be something like: 102.168.10.5."
  }
}

variable "ipaddress-internal" {
  description = "IP address in the existing the network."
  type        = string
  default     = "192.168.13.12"
  validation {
    condition = (
      can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$", var.ipaddress-internal))
    )
    error_message = "Invalid IP address format. It must be something like: 102.168.10.5."
  }
}

# provider specific
variable "enabled" {
  description = "Enable azure deployment."
  type        = bool
}

variable "region" {
  description = "Name of existing region to deploy resources."
}

variable "os_image_publisher" {
  description = "Publisher of the OS image."
  default     = "SUSE"
}

variable "os_image_offer" {
  description = "Offer of the OS image."
  default     = "opensuse-leap-15-3"
}

variable "os_image_sku" {
  description = "SKU of the OS image."
  default     = "gen2"
}

variable "os_image_version" {
  description = "Version of the OS image."
  default     = "2022.01.13"
}

variable "vm_size" {
  description = "Size of the azure VM."
  type        = string
  default     = "Standard_B1s"
}
