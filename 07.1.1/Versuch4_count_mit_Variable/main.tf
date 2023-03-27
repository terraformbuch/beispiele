variable "webservers_count" {
  description = "Number of webservers"
}

resource "openstack_compute_instance_v2" "webservers" {
  count = var.webservers_count

  name        = "webserver${format("%03d", count.index + 1)}"
  flavor_name = "4C-4GB-40GB"
  image_name  = "openSUSE Leap 15.3"
}
