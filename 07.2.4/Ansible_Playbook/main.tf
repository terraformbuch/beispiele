resource "null_resource" "ansible-per-local-exec" {

  provisioner "local-exec" {
    command = <<EOL
      export ANSIBLE_HOST_KEY_CHECKING=False;
      ansible-playbook -u ${var.user} --private-key ${var.ssh_private_key} -i self.public_ip web-playbook.yaml
    EOL
  }
}