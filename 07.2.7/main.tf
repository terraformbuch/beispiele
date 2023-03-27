resource "aws_instance" "my_instance" {
  #[...]

  connection {
    # Details zur Verbindung
    #[...]
  }

  provisioner "local-exec" {
    command = "until [ \"$(ssh -o strictHostKeyChecking=no -o BatchMode=yes -o ConnectTimeout=5 ubuntu@${self.private_ip} echo ok 2>&1)\" = \"ok\" ]; do echo \"Retrying connection...\"; done"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Fertig!'",
    ]
  }
}
