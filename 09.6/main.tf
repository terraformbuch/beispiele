module "pubkey" {
  source = "./pubkey"

  pubkey_value = file(pathexpand("~/.ssh/id_rsa.pub"))
}
