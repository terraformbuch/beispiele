module "Datei1" {
  source = "./modules/create_local_file"

  name_of_file    = "Datei1.txt"
  content_of_file = "Hallo Datei1!\n"
}

module "Datei2" {
  source = "./modules/create_local_file"

  name_of_file    = "Datei2.txt"
  content_of_file = "Hallo Datei2!\n"
}

module "Datei3" {
  source = "./modules/create_local_file"

  name_of_file    = "Datei3.txt"
  content_of_file = "Hallo Datei3!\n"
}

module "Datei4" {
  source = "./modules/create_local_file"

  name_of_file    = "Datei4.txt"
  content_of_file = "Hallo Datei4!\n"
}
