resource "aws_instance" "terraform" {
  ami           = "ami-06ec8443c2a35b0ba"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.terraform.key_name
  network_interface {
    network_interface_id = aws_network_interface.terraform.id
    device_index         = 0
  }
}
