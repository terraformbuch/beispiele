resource "openstack_compute_instance_v2" "webservers" {
  count = 3

  name        = "webserver${count.index + 1}"
  flavor_name = "8C-8GB-40GB"
  image_name  = "openSUSE Leap 15.4"

  network {
    name = "net-to-external-terraform"
  }
}

resource "openstack_compute_instance_v2" "databases" {
  count = 1

  name        = "database${count.index + 1}"
  flavor_name = "8C-32GB-40GB"
  image_name  = "openSUSE Leap 15.4"

  network {
    name = "net-to-external-terraform"
  }
}

resource "openstack_compute_instance_v2" "loadbalancers" {
  count = 2

  name        = "loadbalancer${count.index + 1}"
  flavor_name = "4C-4GB-20GB"
  image_name  = "openSUSE Leap 15.4"

  network {
    name = "net-to-external-terraform"
  }
}
