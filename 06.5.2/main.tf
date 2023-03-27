data "openstack_networking_network_v2" "ein_netzwerk" {
  name = "ein_spezielles_netzwerk"
}

output "network_id" {
  value = data.openstack_networking_network_v2.ein_netzwerk.id
}
