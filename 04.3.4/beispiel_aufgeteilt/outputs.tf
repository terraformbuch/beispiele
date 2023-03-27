output "oeffentliche_ip_addresse" {
  value = openstack_compute_floatingip_associate_v2.my_public_ip_to_instance_association.floating_ip
}
