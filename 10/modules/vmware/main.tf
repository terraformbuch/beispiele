data "vsphere_datacenter" "dc" {
  count = var.enabled ? 1 : 0
  name  = var.datacenter
}

data "vsphere_datastore" "datastore" {
  count         = var.enabled ? 1 : 0
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.dc.0.id
}

data "vsphere_compute_cluster" "cluster" {
  count         = var.enabled ? 1 : 0
  name          = var.cluster
  datacenter_id = data.vsphere_datacenter.dc.0.id
}

data "vsphere_network" "network" {
  count         = var.enabled ? 1 : 0
  name          = var.network
  datacenter_id = data.vsphere_datacenter.dc.0.id
}

data "template_file" "meta_init" {
  template = <<EOF
{
        "local-hostname": "$${local_hostname}"
}
EOF

  vars = {
    local_hostname = "${var.name}"
  }
}

locals {
  os_image_url  = "${var.os_image_base_url}/${var.os_image}"
  os_image_vmdk = replace(var.os_image, ".qcow2", ".vmdk")
  ip            = var.enabled ? vsphere_virtual_machine.webserver.0.default_ip_address : ""
}

resource "null_resource" "os_image_file" {
  count = var.enabled ? 1 : 0
  provisioner "local-exec" {
    command = "test -f ${path.module}/${local.os_image_vmdk} || ( curl -L -o ${path.module}/${var.os_image} ${local.os_image_url} && qemu-img convert -f qcow2 -O vmdk ${path.module}/${var.os_image} ${path.module}/${local.os_image_vmdk})"
  }
}

resource "vsphere_file" "os_image_upload" {
  count              = var.enabled ? 1 : 0
  datacenter         = data.vsphere_datacenter.dc.0.name
  datastore          = data.vsphere_datastore.datastore.0.name
  source_file        = "${path.module}/${local.os_image_vmdk}"
  destination_file   = "${var.name}/${var.name}-os.vmdk"
  create_directories = true

  depends_on = [null_resource.os_image_file]
}

resource "vsphere_virtual_machine" "webserver" {
  count            = var.enabled ? 1 : 0
  name             = var.name
  resource_pool_id = data.vsphere_compute_cluster.cluster.0.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.0.id
  num_cpus         = 1
  memory           = 1024
  guest_id         = "other3xLinux64Guest"
  network_interface {
    network_id = data.vsphere_network.network.0.id
  }
  disk {
    label        = "${var.name}-os"
    attach       = true
    datastore_id = data.vsphere_datastore.datastore.0.id
    path         = "${var.name}/${var.name}-os.vmdk"
  }

  extra_config = {
    "guestinfo.metadata"          = "${base64gzip(data.template_file.meta_init.rendered)}"
    "guestinfo.metadata.encoding" = "gzip+base64"
    "guestinfo.userdata"          = base64gzip(var.user_data)
    "guestinfo.userdata.encoding" = "gzip+base64"
  }

  depends_on = [vsphere_file.os_image_upload]
}

resource "null_resource" "ansible" {
  count = var.enabled ? 1 : 0

  triggers = {
    id = vsphere_virtual_machine.webserver.0.id
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
