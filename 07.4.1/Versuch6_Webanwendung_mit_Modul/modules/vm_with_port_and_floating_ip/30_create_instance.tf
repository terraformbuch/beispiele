# Create the instances

resource "openstack_compute_instance_v2" "instances" {
  name        = var.instance_name_or_prefix
  flavor_name = var.instance_flavor_name
  image_name  = var.instance_image_name

  network {
    port = openstack_networking_port_v2.instance_ports.id
  }
}
