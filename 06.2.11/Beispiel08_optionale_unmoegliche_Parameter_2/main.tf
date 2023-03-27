variable "object_funktioniert" {
  type = object({
    name    = string
    surname = string
  })
}
variable "map_funktioniert_nicht" {
  type = map({
    name    = string
    surname = string
  })
}
