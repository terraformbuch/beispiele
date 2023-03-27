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
