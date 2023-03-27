variable "key" {
  default = "zwei"
}

variable "list" {
  default = {
    "idx_null" = 0,
    "idx_eins" = 1,
    "idx_zwei" = 2,
    "idx_drei" = 3,
    "idx_vier" = 4
  }
}

resource "local_file" "files" {
  filename = "./liste.txt"
  content  = element(var.list[*], "idx_${var.key}")
}
