locals {
  ip              = var.enabled ? openstack_compute_instance_v2.webserver.access_ip_v4 : ""
  ip_bastion      = var.enabled ? openstack_networking_floatingip_v2.bastion.address : ""
  ip_loadbalancer = var.enabled ? "" : ""
}

data "openstack_networking_network_v2" "external_network" {
  name = var.external_network_name
}

resource "openstack_networking_router_v2" "router" {
  name                    = "${var.name}-router"
  admin_state_up          = "true"
  external_network_id     = data.openstack_networking_network_v2.external_network.id
  availability_zone_hints = [var.region_net]
}

resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id = openstack_networking_router_v2.router.id
  subnet_id = openstack_networking_subnet_v2.subnet.id
}

resource "openstack_networking_network_v2" "net" {
  name                    = "${var.name}-net"
  admin_state_up          = "true"
  availability_zone_hints = [var.region_net]
}

resource "openstack_networking_subnet_v2" "subnet" {
  name       = "${var.name}-subnet"
  network_id = openstack_networking_network_v2.net.id
  cidr       = var.iprange-subnet-internal
  ip_version = 4
}

resource "openstack_networking_secgroup_v2" "fw_external_bastion" {
  name = "${var.name}-fw_external_bastion"
}

resource "openstack_networking_secgroup_v2" "fw_external_loadbalancer" {
  name = "${var.name}-fw_external_loadbalancer"
}

resource "openstack_networking_secgroup_rule_v2" "allow_icmp_bastion" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.fw_external_bastion.id
}

resource "openstack_networking_secgroup_rule_v2" "allow_ssh_bastion" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.fw_external_bastion.id
}

resource "openstack_networking_secgroup_rule_v2" "allow_icmp_loadbalancer" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.fw_external_loadbalancer.id
}

resource "openstack_networking_secgroup_rule_v2" "allow_http_loadbalancer" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.fw_external_loadbalancer.id
}

resource "openstack_networking_secgroup_v2" "fw_internal" {
  name = "${var.name}-fw_internal"
}

resource "openstack_networking_secgroup_rule_v2" "allow_all" {
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_ip_prefix  = var.iprange-net-internal
  security_group_id = openstack_networking_secgroup_v2.fw_internal.id
}

resource "openstack_networking_floatingip_v2" "bastion" {
  depends_on = [openstack_networking_router_interface_v2.router_interface]

  pool = var.floatingip_pool
}

resource "openstack_compute_floatingip_associate_v2" "bastion" {
  floating_ip = openstack_networking_floatingip_v2.bastion.address
  instance_id = openstack_compute_instance_v2.bastion.id
}

resource "openstack_networking_port_v2" "bastion" {
  name               = "${var.name}-bastion-port"
  network_id         = openstack_networking_network_v2.net.id
  admin_state_up     = "true"
  security_group_ids = [openstack_networking_secgroup_v2.fw_external_bastion.id]

  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.subnet.id
    ip_address = var.ipaddress-bastion-internal
  }
}

resource "openstack_compute_instance_v2" "bastion" {
  name              = "${var.name}-bastion"
  flavor_name       = var.os_size
  image_id          = var.os_image
  config_drive      = true
  user_data         = var.user_data
  availability_zone = var.region_compute

  network {
    port = openstack_networking_port_v2.bastion.id
  }
}

resource "openstack_networking_port_v2" "loadbalancer" {
  name               = "${var.name}-loadbalancer-port"
  network_id         = openstack_networking_network_v2.net.id
  admin_state_up     = "true"
  security_group_ids = [openstack_networking_secgroup_v2.fw_external_loadbalancer.id]

  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.subnet.id
    ip_address = var.ipaddress-loadbalancer-internal
  }
}

resource "openstack_networking_floatingip_v2" "loadbalancer" {
  depends_on = [openstack_networking_router_interface_v2.router_interface]

  pool = var.floatingip_pool
}

# resource "openstack_lb_loadbalancer_v2" "loadbalancer" {
#   depends_on         = [openstack_compute_instance_v2.webserver]
#
#   name               = "${var.name}-loadbalancer"
#   vip_subnet_id      = openstack_networking_subnet_v2.subnet.id
#   admin_state_up     = "true"
#   security_group_ids = [openstack_networking_secgroup_v2.fw_external_loadbalancer.id]
# }

resource "openstack_lb_loadbalancer_v2" "loadbalancer" {
  depends_on = [openstack_compute_instance_v2.webserver]

  name           = "${var.name}-loadbalancer"
  vip_subnet_id  = openstack_networking_subnet_v2.subnet.id
  vip_port_id    = openstack_networking_port_v2.loadbalancer.id
  admin_state_up = true
}

resource "openstack_lb_pool_v2" "loadbalancer_pool" {
  protocol        = "HTTP"
  lb_method       = "ROUND_ROBIN"
  loadbalancer_id = openstack_lb_loadbalancer_v2.loadbalancer.id
}

resource "openstack_lb_member_v2" "loadbalacer_member" {
  pool_id       = openstack_lb_pool_v2.loadbalancer_pool.id
  subnet_id     = openstack_networking_subnet_v2.subnet.id
  address       = openstack_networking_port_v2.webserver.fixed_ip.0.ip_address
  protocol_port = 80
}

resource "openstack_networking_port_v2" "webserver" {
  name               = "${var.name}-port"
  network_id         = openstack_networking_network_v2.net.id
  admin_state_up     = "true"
  security_group_ids = [openstack_networking_secgroup_v2.fw_internal.id]

  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.subnet.id
    ip_address = var.ipaddress-internal
  }
}

resource "openstack_compute_instance_v2" "webserver" {
  name              = var.name
  flavor_name       = var.os_size
  image_id          = var.os_image
  config_drive      = true
  user_data         = var.user_data
  availability_zone = var.region_compute

  network {
    port = openstack_networking_port_v2.webserver.id
  }
}

resource "null_resource" "ansible" {
  triggers = {
    id = openstack_compute_instance_v2.webserver.id
  }

  connection {
    host                = local.ip
    type                = "ssh"
    user                = var.admin_user
    private_key         = file(pathexpand(var.private_key))
    bastion_host        = local.ip_bastion
    bastion_user        = var.admin_user
    bastion_private_key = file(pathexpand(var.private_key))
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait"
    ]
  }

  provisioner "local-exec" {
    command = <<EOL
        export ANSIBLE_HOST_KEY_CHECKING=False;
        export ANSIBLE_SSH_COMMON_ARGS='-A -o ProxyCommand="ssh -W %h:%p ${var.admin_user}@${local.ip_bastion}"'
        until nc -zv ${local.ip_bastion} 22; do sleep 10; done
        pgrep ssh-agent || eval $(ssh-agent) && ssh-add ${var.private_key}
        ansible-playbook -u ${var.admin_user} --private-key ${var.private_key} -i ${local.ip}, ansible/web-playbook.yaml
      EOL
  }
}

#resource "null_resource" "open_url" {
#  depends_on = [null_resource.ansible]
#
#  triggers = {
#    id = null_resource.ansible.id
#  }
#
#  provisioner "local-exec" {
#    command = <<EOL
#        curl http://${local.ip_loadbalancer}
#      EOL
#  }
#}
