#
# floating IPs
#

output "floating_ips" {
  value = openstack_networking_floatingip_v2.floating_ips
}

#
# network ports
#

output "instance_ports" {
  value = openstack_networking_port_v2.instance_ports
}

#
# instances
#

output "instances" {
  value = openstack_compute_instance_v2.instances
}

#
# floating IP associations
#

output "floating_ip_associations" {
  value = openstack_compute_floatingip_associate_v2.floating_ip_associations
}
