terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

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

output "cirros_ip" {
  description = "Die private IP Addresse der virtuellen Machine."
  value       = libvirt_domain.cirros.network_interface.0.addresses
}
