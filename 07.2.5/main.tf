data "template_file" "web-playbook" {
  template = file("./web-playbook.yml")
}

resource "null_resource" "web-playbook-auf-webserver" {

  provisioner "file" {
    content     = data.template_file.web-playbook.rendered
    destination = "/tmp/web-playbook.yml"
  }
}
