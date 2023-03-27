data "local_file" "public_key" {
  filename = pathexpand("~/.ssh/id_rsa.pub")
}

output "public_key" {
  value = data.local_file.public_key.content
}
