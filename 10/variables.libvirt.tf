variable "libvirt_qemu_uri" {
  description = "URI to connect with the qemu-service."
  default     = "qemu:///system"
}

variable "libvirt_bridge_device" {
  description = "Which existing bride device to use."
  type        = string
  default     = "virbr0"
}

variable "libvirt_network_name" {
  description = "Which existing network to use."
  type        = string
  default     = "default"
}
