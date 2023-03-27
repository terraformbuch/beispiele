variable "positive_zahl" {
  default = "5"
}

variable "negative_zahl" {
  default = "-5"
}

#output "negierte_positive_zahl" {
#  value = !var.positive_zahl
#}
#output "negierte_negative_zahl" {
#  value = !var.negative_zahl
#}

output "minus_positive_zahl" {
  value = -var.positive_zahl
}
output "minus_negative_zahl" {
  value = -var.negative_zahl
}
