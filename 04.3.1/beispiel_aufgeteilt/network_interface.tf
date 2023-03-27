resource "aws_network_interface" "terraform" {
  subnet_id       = aws_subnet.terraform.id
  security_groups = [aws_security_group.terraform.id]
}
