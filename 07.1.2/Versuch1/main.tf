resource "openstack_compute_instance_v2" "webservers" {
  for_each = {
    webserver_small  = "4C-4GB-20GB"
    webserver_medium = "4C-4GB-30GB"
    webserver_big    = "4C-4GB-40GB"
  }

  name        = each.key
  flavor_name = each.value
  image_name  = "openSUSE Leap 15.4"
}
