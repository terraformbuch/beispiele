terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
  }
}

provider "openstack" {
  cloud = "terraformbuch"
}

resource "openstack_compute_keypair_v2" "my_keypair" {
  name       = "SSH-Schluessel Tux"
  public_key = file(pathexpand("~/.ssh/id_rsa.pub"))
}

resource "openstack_compute_secgroup_v2" "my_security_group" {
  name        = "Meine Sicherheitsgruppe"
  description = "SSH und ICMP erlauben"

  rule {
    cidr        = "0.0.0.0/0"
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
  }

  rule {
    cidr        = "0.0.0.0/0"
    from_port   = -1
    to_port     = -1
    ip_protocol = "icmp"
  }
}

resource "openstack_compute_instance_v2" "my_instance" {
  name            = "beispiel-instanz"
  flavor_name     = "2C-2GB-10GB"
  image_name      = "Ubuntu 22.04"
  key_pair        = openstack_compute_keypair_v2.my_keypair.name
  security_groups = [openstack_compute_secgroup_v2.my_security_group.name]

  network {
    name = "net-to-external-terraform"
  }
}

resource "openstack_networking_floatingip_v2" "my_public_ip" {
  pool = "external"
}

resource "openstack_compute_floatingip_associate_v2" "my_public_ip_to_instance_association" {
  instance_id = openstack_compute_instance_v2.my_instance.id
  floating_ip = openstack_networking_floatingip_v2.my_public_ip.address
}

output "oeffentliche_ip_addresse" {
  value = openstack_compute_floatingip_associate_v2.my_public_ip_to_instance_association.floating_ip
}
