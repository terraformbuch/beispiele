module "vm0" {
  source = "./vm"

  flavor = "2C-2GB-10GB"
  image  = "Ubuntu 20.04"
  name   = "test"
}

output "ips" {
  value = module.vm0.ip
}
