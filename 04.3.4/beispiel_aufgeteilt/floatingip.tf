resource "openstack_networking_floatingip_v2" "my_public_ip" {
  pool = "external"
}
