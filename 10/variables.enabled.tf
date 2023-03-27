variable "aws_enabled" {
  description = "Enable aws deployment."
  type        = bool
  default     = true
}

variable "azure_enabled" {
  description = "Enable azure deployment."
  type        = bool
  default     = false
}

variable "gcp_enabled" {
  description = "Enable gcp deployment."
  type        = bool
  default     = false
}

variable "libvirt_enabled" {
  description = "Enable libvirt deployment."
  type        = bool
  default     = false
}

variable "openstack_enabled" {
  description = "Enable openstack deployment."
  type        = bool
  default     = false
}

variable "vmware_enabled" {
  description = "Enable vmware deployment."
  type        = bool
  default     = false
}
