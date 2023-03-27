output "ipaddress" {
  value = local.azure_ip
}

output "ipaddress_bastion" {
  value = local.azure_ip_bastion
}

output "ipaddress_loadbalancer" {
  value = local.azure_ip_loadbalancer
}

output "admin_password" {
  value = random_password.admin_password.result
}
