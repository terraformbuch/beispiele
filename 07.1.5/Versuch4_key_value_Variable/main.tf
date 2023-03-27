
variable "map_of_networks" {
  default = {
    network1 = "1234-5678"
    network2 = "aaaa-bbbb"
  }
}

resource "openstack_compute_instance_v2" "webserver" {
  name        = "webserver"
  flavor_name = "4C-4GB-40GB"
  image_name  = "openSUSE Leap 15.4"

  dynamic "network" {
    for_each = var.map_of_networks
    iterator = current_network
    content {
      name = current_network.key
      uuid = current_network.value
    }
  }
}
