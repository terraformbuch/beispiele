variable "image" {
  default = "Ubuntu 22.04"
}

variable "pubkey" {
  default = "ssh-rsa ..."
}

variable "counter" {
  default = "3"
}

variable "vip_pool" {
  default = "YYY"
}

variable "secgroups" {
  default = ["ssh", "http"]
}

variable "zone" {
  default = "south-1"
}

variable "flavor" {
  default = "4C-4GB-40GB"
}

variable "project" {
  default = "common-sandbox"
}
