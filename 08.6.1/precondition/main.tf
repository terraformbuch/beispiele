resource "openstack_compute_instance_v2" "webserver" {
  lifecycle {
    precondition {
      condition     = var.name == ""
      error_message = "name must not be empty"
    }
  }

  name        = "webserver"
  flavor_name = "4C-4GB-40GB"
  image_name  = "openSUSE Leap 15.3"
}
