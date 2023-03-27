terraform {
  cloud {
    organization = "terraformbuch"

    workspaces {
      name = "workspace-mit-der-kommandozeile"
    }
  }
}
