resource "openstack_compute_instance_v2" "webserver" {
  name        = "webserver"
  flavor_name = "4C-4GB-40GB"
  image_name  = "openSUSE Leap 15.4"

  network {
    uuid = "1234-5678"
  }
}
