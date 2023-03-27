terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "terraformbuch"

    workspaces {
      name = "production"
    }
  }
}
