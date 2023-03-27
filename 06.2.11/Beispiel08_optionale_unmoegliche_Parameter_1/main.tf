# optional geht nur bei object-Types
variable "string_mit_optional" {
  type = optional(string)
}

variable "anzahl_instanzen" {
  type = optional(number, 5)
}
