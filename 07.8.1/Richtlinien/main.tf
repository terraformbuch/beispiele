variable "firma" {
  default = "OSISM"
}

output "ausgabe" {
  value = "Hallo %{ if var.firma != "" }${var.firma}%{ else }B1 Systems%{ endif }!"
}
