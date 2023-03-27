variable "person_info" {
  default = { "name" = "Marta Muster", "age" = 50}
  type = object({
    name            = string
    age             = number
    favorite_dishes = optional(
      list (string)
    )
  })
}
