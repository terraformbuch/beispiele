resource "openstack_compute_instance_v2" "webserver" {
  lifecycle {
    postcondition {
      condition     = self.access_ip_v6 != ""
      error_message = "instance has no ipv6 address assigned"
    }
  }

  name        = "webserver"
  flavor_name = "4C-4GB-40GB"
  image_name  = "openSUSE Leap 15.3"
}
