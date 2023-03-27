variable "zeichenketten" {
  type = map(string)
  default = {
    "datenbank" = "db01",
    "webserver" = "web01",
    "proxy"     = "proxy01"
  }
}
