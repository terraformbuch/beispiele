resource "libvirt_network" "network" {
  name   = "terraform_netzwerk"
  mode   = "nat"
  domain = "terraformbuch.de"

  addresses = [
    "192.168.42.0/24"
  ]

  dns {
    enabled = true
  }
}
