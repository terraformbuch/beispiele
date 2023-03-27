resource "null_resource" "ssh-key-anlegen" {

  provisioner "local-exec" {
    command = "ssh-keygen -N '' -t ed25519 -f terraform_id_ed25519"
  }

  provisioner "local-exec" {
    command = "rm terraform_id_ed25519 terraform_id_ed25519.pub"
    when    = destroy
  }

}
