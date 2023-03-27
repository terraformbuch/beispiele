variable "my_map" {
  default = {
    "foo" = "eins"
    "bar" = "zwei"
    "baz" = "drei"
  }
}

output "ausgabe_ohne_lookup" {
  value = var.my_map["foo"]
}
