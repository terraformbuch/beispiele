provider "openstack" {
  tenant_name = "webserver"
  auth_url    = "https://api.openstack.terraformbuch.de:5000/v2.0"
  use_octavia = true
}
