resource "openstack_compute_keypair_v2" "my_keypair" {
  name       = "SSH-Schluessel Tux"
  public_key = file(pathexpand("~/.ssh/id_rsa.pub"))
}
