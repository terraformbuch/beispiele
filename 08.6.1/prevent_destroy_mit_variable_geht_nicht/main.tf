variable "variable_for_prevent_destroy" {
  default = true
}

resource "openstack_compute_instance_v2" "webserver" {
  lifecycle {
    # Die Nutzung von Variablen führt zu einem Fehler
    prevent_destroy = vars.variable_for_prevent_destroy
  }

  name        = "webserver"
  flavor_name = "4C-4GB-40GB"
  image_name  = "openSUSE Leap 15.3"
}
