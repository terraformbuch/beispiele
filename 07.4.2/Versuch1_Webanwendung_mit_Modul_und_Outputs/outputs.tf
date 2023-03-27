#
# Floating IPs of all available groups
#
output "floating_ips_webservers" {
  value = module.webservers[*].floating_ips.address
}
output "floating_ips_databases" {
  value = module.databases[*].floating_ips.address
}
output "floating_ips_loadbalancers" {
  value = module.loadbalancers[*].floating_ips.address
}
