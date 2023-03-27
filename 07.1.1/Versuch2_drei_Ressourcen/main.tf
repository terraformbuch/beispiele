resource "openstack_compute_instance_v2" "webserver1" {
  name        = "webserver1"
  flavor_name = "4C-4GB-40GB"
  image_name  = "openSUSE Leap 15.3"
}

resource "openstack_compute_instance_v2" "webserver2" {
  name        = "webserver2"
  flavor_name = "4C-4GB-40GB"
  image_name  = "openSUSE Leap 15.3"
}

resource "openstack_compute_instance_v2" "webserver3" {
  name        = "webserver3"
  flavor_name = "4C-4GB-40GB"
  image_name  = "openSUSE Leap 15.3"
}
