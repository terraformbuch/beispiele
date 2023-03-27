variable "some_list" {
  default = [
    {
      "name" = "eins",
      "id"   = 1
    },
    {
      "name" = "zwei",
      "id"   = 2
    }
  ]
}

output "ausgabe" {
  value = var.some_list[*].id
}

output "veraltete_schreibweise" {
  value = var.some_list.*.id
}
