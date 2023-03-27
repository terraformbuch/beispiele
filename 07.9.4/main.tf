output "oeffentlicher_ssh_schluessel" {
  value = file(pathexpand("~/.ssh/id_rsa.pub"))
}
