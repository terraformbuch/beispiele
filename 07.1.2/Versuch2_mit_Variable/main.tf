variable "list_of_servers" {
  description = "List of servers and their flavors"
  default = {
    webserver_small  = "4C-4GB-20GB",
    webserver_medium = "4C-4GB-30GB",
    webserver_big    = "4C-4GB-40GB"
  }
}

resource "openstack_compute_instance_v2" "webservers" {
  for_each = var.list_of_servers

  name        = each.key
  flavor_name = each.value
  image_name  = "openSUSE Leap 15.4"
}
