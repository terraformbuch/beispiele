variable "pubkey_location" {
  default = "~/.ssh/id_rsa.pub"
}

data "local_file" "pubkey" {
  filename = pathexpand(var.pubkey_location)
}

output "public_key" {
  value = data.local_file.pubkey.content
}
