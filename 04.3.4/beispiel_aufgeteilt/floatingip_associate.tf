resource "openstack_compute_floatingip_associate_v2" "my_public_ip_to_instance_association" {
  instance_id = openstack_compute_instance_v2.my_instance.id
  floating_ip = openstack_networking_floatingip_v2.my_public_ip.address
}
