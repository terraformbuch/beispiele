variable "my_map" {
  default = {
    "foo" = "eins"
    "bar" = "zwei"
    "baz" = "drei"
  }
}

output "ausgabe_mit_lookup" {
  value = lookup(var.my_map, "foo", "Huch, hier fehlt ein Wert")
}

output "ausgabe_uengueltiger_key_mit_lookup" {
  value = lookup(var.my_map, "XXX", "Huch, hier fehlt ein Wert")
}
