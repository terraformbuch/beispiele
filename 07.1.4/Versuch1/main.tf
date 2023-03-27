variable "development_or_production" {
  type    = string
  default = "development"
}

resource "openstack_compute_instance_v2" "webserver" {
  name        = "webserver"
  flavor_name = var.development_or_production == "production" ? "64C-64G-100GB" : "4C-4GB-40GB"
  image_name  = "openSUSE Leap 15.4"
}
