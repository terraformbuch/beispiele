
variable "list_of_network_uuids" {
  default = ["1234-5678", "aaaa-bbbb"]
}

resource "openstack_compute_instance_v2" "webserver" {
  name        = "webserver"
  flavor_name = "4C-4GB-40GB"
  image_name  = "openSUSE Leap 15.4"

  dynamic "network" {
    for_each = var.list_of_network_uuids
    content {
      uuid = network.value
    }
  }
}
