# Create floating IPs for clients

resource "openstack_networking_floatingip_v2" "floating_ips" {
  pool = var.floating_ip_pool
}
