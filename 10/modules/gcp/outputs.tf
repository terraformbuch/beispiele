output "ipaddress" {
  value = local.gcp_ip
}

output "ipaddress_bastion" {
  value = local.gcp_ip_bastion
}

output "ipaddress_loadbalancer" {
  value = local.gcp_ip_loadbalancer
}
