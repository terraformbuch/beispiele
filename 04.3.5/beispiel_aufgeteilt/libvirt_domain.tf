resource "libvirt_domain" "cirros" {
  name   = "cirros"
  memory = 1024
  vcpu   = 1

  network_interface {
    network_name   = libvirt_network.network.name
    wait_for_lease = true
  }

  cpu {
    mode = "host-passthrough"
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  disk {
    volume_id = libvirt_volume.cirros_rootdisk.id
  }

  graphics {
    type        = "vnc"
    listen_type = "address"
    autoport    = true
  }
}

