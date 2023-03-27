# create ports to use with the instances

resource "openstack_networking_port_v2" "instance_ports" {
  name               = var.instance_name_or_prefix
  network_id         = var.port_network_id
  admin_state_up     = "true"
  security_group_ids = var.port_security_group_ids
}
