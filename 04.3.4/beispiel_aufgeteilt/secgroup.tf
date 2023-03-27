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
