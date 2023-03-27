variable "gcp_credentials" {
  description = "Path to a GCP credentials JSON file."
}

variable "gcp_project" {
  description = "Name of existing project to deploy resources."
  default     = ""
}

variable "gcp_region" {
  description = "Name of existing region to deploy resources."
  default     = "europe-west1"
}

variable "gcp_os_image" {
  description = "OS image."
  default     = "opensuse-cloud/opensuse-leap"
}

variable "gcp_vm_size" {
  description = "Size of the gcp VM."
  type        = string
  default     = "custom-1-1024"
}
