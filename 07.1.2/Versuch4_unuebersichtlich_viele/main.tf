resource "openstack_compute_instance_v2" "webservers" {
  for_each = {
    webserver_small1  = "4C-4GB-20GB"
    webserver_small2  = "4C-4GB-20GB"
    webserver_small3  = "4C-4GB-20GB"
    webserver_small4  = "4C-4GB-20GB"
    webserver_small5  = "4C-4GB-20GB"
    webserver_medium1 = "4C-4GB-30GB"
    webserver_medium2 = "4C-4GB-30GB"
    webserver_medium3 = "4C-4GB-30GB"
    webserver_big1    = "4C-4GB-40GB"
    webserver_big2    = "4C-4GB-40GB"
    webserver_big3    = "4C-4GB-40GB"
    webserver_big4    = "4C-4GB-40GB"
    webserver_big5    = "4C-4GB-40GB"
    webserver_big6    = "4C-4GB-40GB"
  }
  name        = each.key
  flavor_name = each.value
  image_name  = "openSUSE Leap 15.4"
}
