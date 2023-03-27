variable "server_name" {
  default = "webserver"
}

variable "server_ips" {
  default = {
    "webserver_1" = "10.100.50.101"
    "webserver_2" = "10.100.50.102"
    "webserver_3" = "10.100.50.103"
    "dbserver_1"  = "10.100.40.101"
    "dbserver_2"  = "10.100.40.102"
  }
}

resource "null_resource" "some_resource" {
  count = 3

  provisioner "local-exec" {
    command = "echo ${lookup(var.server_ips, "${var.server_name}_${count.index + 1}", "")}"
  }
}
