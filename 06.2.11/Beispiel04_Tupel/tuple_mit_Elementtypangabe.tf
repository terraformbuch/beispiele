variable "tuple_2" {
  default = ["webserver", 42]
  type    = tuple([string, number])
}
