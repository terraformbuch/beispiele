variable "person_info" {
  default = { "name" = "Marta Muster", "age" = 50, "favorite_dishes" = ["pizza"] }
  type = object({
    name            = string
    age             = number
    favorite_dishes = list(string)
  })
}

output "person_info_ausgeben" {
  value = var.person_info
}

