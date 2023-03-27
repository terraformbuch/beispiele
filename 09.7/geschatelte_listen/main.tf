module "ha-vms" {
  count  = 3000
  source = "./ha-vm"
}

output "ips" {
  # Achtung, dieser Code funktioniert nicht und generiert einen Fehler!
  value = module.ha-vms[*].ips[*]
}

#output "ips" {
#  value = [
#    for module in module.vms[*]:
#      module.ips
#  ]
#}
