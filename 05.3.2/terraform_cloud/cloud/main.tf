terraform {
  cloud {
    hostname     = "app.terraform.io"
    organization = "terraformbuch"

    workspaces {
      name = "production"
    }
  }
}
