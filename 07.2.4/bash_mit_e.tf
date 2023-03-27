resource "null_resource" "local-exec-bash-mit-e" {

  provisioner "local-exec" {
    command     = "echo 'Hallo Terraform-Buch!'"
    interpreter = ["bash", "-e", "-c"]
  }

}
