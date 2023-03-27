variable "azure_region" {
  description = "Name of existing region to deploy resources."
}

variable "azure_os_image_publisher" {
  description = "Publisher of the OS image."
  default     = "SUSE"
}

variable "azure_os_image_offer" {
  description = "Offer of the OS image."
  default     = "opensuse-leap-15-3"
}

variable "azure_os_image_sku" {
  description = "SKU of the OS image."
  default     = "gen2"
}

variable "azure_os_image_version" {
  description = "Version of the OS image."
  default     = "2022.01.13"
}

variable "azure_vm_size" {
  description = "Size of the azure VM."
  type        = string
  default     = "Standard_B1s"
}
