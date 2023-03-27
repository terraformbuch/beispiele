resource "openstack_compute_instance_v2" "my_instance" {
  name            = "beispiel-instanz"
  flavor_name     = "2C-2GB-10GB"
  image_name      = "Ubuntu 22.04"
  key_pair        = openstack_compute_keypair_v2.my_keypair.name
  security_groups = [openstack_compute_secgroup_v2.my_security_group.name]

  network {
    name = "net-to-external-terraform"
  }
}
