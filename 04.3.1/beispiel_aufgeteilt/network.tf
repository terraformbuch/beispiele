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
