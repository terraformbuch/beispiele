variable "variable" {
  default = 5.4
}

output "ausgabe" {
  value = "${floor(var.variable) * 2}"
}
