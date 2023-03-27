variable "zahlen" {
  type = map(number)
  default = {
    "datenbank" = 8,
    "webserver" = 4,
    "proxy"     = 2
  }
}
