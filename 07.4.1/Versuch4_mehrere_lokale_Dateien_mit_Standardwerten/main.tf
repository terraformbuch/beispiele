module "Datei1" {
  source = "./modules/create_local_file"

  name_of_file    = "Datei1.txt"
  content_of_file = "Hallo Datei1!\n"
}

module "Datei2" {
  source = "./modules/create_local_file"

  name_of_file    = "Datei2.txt"
  content_of_file = "Hallo Datei2!\n"
  # Achtung! Die file_permissions funktionieren ggf. nicht mehr
  # siehe https://github.com/hashicorp/terraform-provider-local/issues/147
  file_permissions = "0777"
}
