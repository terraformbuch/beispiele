resource "openstack_compute_instance_v2" "webservers_small" {
  count = 5

  name        = "webserver_small${count.index + 1}"
  flavor_name = "4C-4GB-20GB"
  image_name  = "openSUSE Leap 15.4"
}

resource "openstack_compute_instance_v2" "webservers_medium" {
  count = 3

  name        = "webserver_medium${count.index + 1}"
  flavor_name = "4C-4GB-30GB"
  image_name  = "openSUSE Leap 15.4"
}

resource "openstack_compute_instance_v2" "webservers_big" {
  count = 6

  name        = "webserver_big${count.index + 1}"
  flavor_name = "4C-4GB-40GB"
  image_name  = "openSUSE Leap 15.4"
}
