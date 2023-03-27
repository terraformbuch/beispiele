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
  description = "Enable gcp deployment."
  type        = bool
}

variable "project" {
  description = "Name of existing project to deploy resources."
}

variable "region" {
  description = "Name of existing region to deploy resources."
  default     = "europe-west1"
}

# gcloud compute images list --project opensuse-cloud --no-standard-images
variable "os_image" {
  description = "OS image."
  # default     = "opensuse-cloud/opensuse-leap/opensuse-leap-15-3-v20220112"
  default = "opensuse-cloud/opensuse-leap"
}

variable "vm_size" {
  description = "Size of the gcp VM."
  type        = string
  default     = "custom-1-1024"
}
