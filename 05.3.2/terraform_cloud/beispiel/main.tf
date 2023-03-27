terraform {
  cloud {
    hostname     = "app.terraform.io"
    organization = "terraformbuch"

    workspaces {
      name = "tux_workspace"
    }
  }
}

resource "null_resource" "debug" {
  provisioner "local-exec" {
    command = "echo test"
  }
}
