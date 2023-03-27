resource "libvirt_pool" "base" {
  name = "base"
  type = "dir"
  path = "/var/lib/libvirt/images"
}

resource "libvirt_volume" "cirros_rootdisk" {
  name   = "cirros_disk.qcow2"
  pool   = libvirt_pool.base.name
  source = "https://github.com/cirros-dev/cirros/releases/download/0.6.0/cirros-0.6.0-x86_64-disk.img"
}
