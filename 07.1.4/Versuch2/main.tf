variable "high_availability" {
  type    = bool
  default = true
}

resource "openstack_compute_instance_v2" "webserver" {
  count = (var.high_availability == true ? 3 : 1)

  name        = "webserver"
  flavor_name = "4C-4GB-40GB"
  image_name  = "openSUSE Leap 15.4"
}
