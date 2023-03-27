variable "variable" {
  default = "foo"
}

output "ausgabe" {
  value = "${var.variable} bar"
}
