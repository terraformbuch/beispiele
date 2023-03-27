terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_vpc" "terraform" {
  cidr_block = "172.16.0.0/16"
}

resource "aws_internet_gateway" "terraform" {
  vpc_id = aws_vpc.terraform.id
}

resource "aws_subnet" "terraform" {
  vpc_id                  = aws_vpc.terraform.id
  cidr_block              = "172.16.10.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true
}

resource "aws_route_table" "terraform" {
  vpc_id = aws_vpc.terraform.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform.id
  }
}

resource "aws_route_table_association" "terraform" {
  subnet_id      = aws_subnet.terraform.id
  route_table_id = aws_route_table.terraform.id
}

resource "aws_security_group" "terraform" {
  name   = "Erlaube SSH von allen IPs"
  vpc_id = aws_vpc.terraform.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "terraform" {
  key_name   = "terraform-key"
  public_key = file(pathexpand("~/.ssh/id_ed25519.pub"))
}

resource "aws_network_interface" "terraform" {
  subnet_id       = aws_subnet.terraform.id
  security_groups = [aws_security_group.terraform.id]
}

resource "aws_instance" "terraform" {
  ami           = "ami-06ec8443c2a35b0ba"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.terraform.key_name

  network_interface {
    network_interface_id = aws_network_interface.terraform.id
    device_index         = 0
  }
}

output "Public_IP_der_VM" {
  value = aws_instance.terraform.public_ip
}
