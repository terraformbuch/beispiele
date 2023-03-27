resource "vsphere_virtual_machine" "vm" {
  name             = "BeispielVM"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus         = 2
  memory           = 2048
  guest_id         = "other3xLinux64Guest"

  wait_for_guest_net_timeout = 0

  cdrom {
    datastore_id = data.vsphere_datastore.datastore.id
    path         = "/images/ubuntu-22.04.1-live-server-amd64.iso"
  }

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label = "disk0"
    size  = 20
  }
}
