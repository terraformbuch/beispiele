output "cirros_ip" {
  description = "Die private IP Addresse der virtuellen Machine."
  value       = libvirt_domain.cirros.network_interface.0.addresses
}
