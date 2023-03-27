variable "person_info" {
  type = object({
    name            = string
    age             = number
    favorite_dishes = optional(
      list(string), ["pizza"]
    )
  })
}

output "person_info_ausgeben" {
  value = var.person_info
}
