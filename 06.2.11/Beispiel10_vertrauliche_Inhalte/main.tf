variable "passwort" {
  default   = "supersicher"
  sensitive = true
}

resource "local_file" "passwort" {
  content  = var.passwort
  filename = "passwort.txt"
}
