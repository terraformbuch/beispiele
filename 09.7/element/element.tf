variable "list" {
  default = [
    "eins",
    "zwei",
    "drei"
  ]
}

resource "x_cloud.some_resource" "some_name" {
  count = length(var.list)

  eine_variable = element(var.list[*], count.index)
}
