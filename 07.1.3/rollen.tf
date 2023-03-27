variable "map_of_users" {
  default = {
    "christian" = {
      "role"    = "netadmin",
      "company" = "B1 Systems",
      "strikes" = "0",
    },
    "eike" = {
      "role"    = "dbadmin",
      "company" = "B1 Systems",
      "strikes" = "0",
    },
    "johannes" = {
      "role"    = "admin",
      "company" = "B1 Systems",
      "strikes" = "1",
    },
    "tim" = {
      "role"    = "admin",
      "company" = "OSISM",
      "strikes" = "2",
    },
    "thorsten" = {
      "role"    = "user",
      "company" = "B1 Systems",
      "strikes" = "0",
    }
  }
}

output "rollen" {
  value = { for name, user in var.map_of_users : user.role => name... }
}
