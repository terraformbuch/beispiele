# Associate floating IPs with the instances

resource "openstack_compute_floatingip_associate_v2" "floating_ip_associations" {
  floating_ip = openstack_networking_floatingip_v2.floating_ips.address
  instance_id = openstack_compute_instance_v2.instances.id
}
