locals {
  os_image_url = "${var.os_image_base_url}/${var.os_image}"
  ip           = var.enabled ? libvirt_domain.webserver.0.network_interface.0.addresses.0 : ""
}

#resource "null_resource" "os_image_file" {
#  provisioner "local-exec" {
#    command = "test -f ${path.module}/${var.os_image} || curl -L -o ${path.module}/${var.os_image} ${local.os_image_url}"
#  }
#}

resource "libvirt_network" "network" {
  count = var.enabled ? 1 : 0

  name   = "${var.name}-network"
  bridge = "virbr1312"
  mode   = "nat"
  #addresses = [var.iprange]
  addresses = ["13.12.0.0/24"]
  autostart = true

  dhcp {
    enabled = "true"
  }

  dns {
    enabled = true
  }
}

resource "libvirt_cloudinit_disk" "cloudinit" {
  count = var.enabled ? 1 : 0

  name      = "cloudinit-${var.name}.iso"
  user_data = var.user_data
  pool      = var.storage_pool
  # network_config = var.network_config
}

resource "libvirt_volume" "os_base_volume" {
  count = var.enabled ? 1 : 0

  name = var.os_image
  #name = "base-${var.os_image}"
  source = local.os_image_url
  pool   = var.storage_pool
}

resource "libvirt_volume" "os_webserver" {
  count = var.enabled ? 1 : 0

  name             = "${var.name}-os-webserver"
  base_volume_id   = libvirt_volume.os_base_volume.0.id
  base_volume_pool = var.storage_pool
  size             = 10737418240
}

resource "libvirt_domain" "webserver" {
  count = var.enabled ? 1 : 0

  name       = var.name
  memory     = 512
  vcpu       = 1
  qemu_agent = true
  cloudinit  = libvirt_cloudinit_disk.cloudinit.0.id

  disk {
    volume_id = libvirt_volume.os_webserver.0.id
  }

  network_interface {
    wait_for_lease = false
    network_name = libvirt_network.network.0.name
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

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

  cpu {
    mode = "host-passthrough"
  }
}

resource "null_resource" "ansible" {
  count = var.enabled ? 1 : 0

  triggers = {
    id = libvirt_domain.webserver.0.id
  }

  connection {
    host        = local.ip
    type        = "ssh"
    user        = var.admin_user
    private_key = file(pathexpand(var.private_key))
    # bastion_host = local.bastion_ip
    # bastion_user        = var.admin_user
    # bastion_private_key = var.admin_user
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait"
    ]
  }

  provisioner "local-exec" {
    command = <<EOL
        export ANSIBLE_HOST_KEY_CHECKING=False;
        until nc -zv ${local.ip} 22; do sleep 10; done
        ansible-playbook -u ${var.admin_user} --private-key ${var.private_key} -i ${local.ip}, ansible/web-playbook.yaml
      EOL
  }
}

resource "null_resource" "open_url" {
  count      = var.enabled ? 1 : 0
  depends_on = [null_resource.ansible.0]

  triggers = {
    id = null_resource.ansible.0.id
  }

  provisioner "local-exec" {
    command = <<EOL
        curl http://${local.ip}
      EOL
  }
}
