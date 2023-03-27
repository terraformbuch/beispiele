#
# floating IP
#

variable "floating_ip_pool" {
  description = "Which pool to create the floating IP in?"
  default     = "external"
}

#
# network port
#

variable "port_network_id" {
  description = "ID of the network where the port is to be created"
  default     = "bc08a5f1-edfc-4bfd-902f-2beea55af105"
}

variable "port_security_group_ids" {
  type        = list(any)
  description = "List of security group IDs"
  default     = []
}

#
# instance
#

variable "instance_name_or_prefix" {
  description = "Name for the new instance"
}

variable "instance_flavor_name" {
  description = "Name of the flavor to use for the new instance"
  default     = "4C-8GB-40GB"
}

variable "instance_image_name" {
  description = "Name of the image to use for the new instance"
  default     = "openSUSE Leap 15.4"
}
