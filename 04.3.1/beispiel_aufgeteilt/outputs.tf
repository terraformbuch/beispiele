output "Public_IP_der_VM" {
  value = aws_instance.terraform.public_ip
}
