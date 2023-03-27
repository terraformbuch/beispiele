resource "null_resource" "schlafen" {
  provisioner "local-exec" {
    command = "sleep 30"
  }
}
