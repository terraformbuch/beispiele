variable "pubkey_value" {}

variable "pubkey_expiration" {
  default = null
}

resource "x_cloud.public_key" "pubkey" {
  public_key = var.pubkey_value
  expiration = var.pubkey_expiration
}
