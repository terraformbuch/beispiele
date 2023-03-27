resource "openstack_compute_instance_v2" "webservers" {
  for_each = toset(["webserver1", "webserver2", "webserver3"])

  name        = each.key
  flavor_name = "4C-4GB-40GB"
  image_name  = "openSUSE Leap 15.4"
}
