output "ipaddress" {
  value = vsphere_virtual_machine.webserver.0.default_ip_address
}
