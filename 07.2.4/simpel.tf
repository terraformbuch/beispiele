resource "null_resource" "local-exec-simpel" {

  provisioner "local-exec" {
    command = "echo 'Hallo Terraform-Buch!'"
  }

}
