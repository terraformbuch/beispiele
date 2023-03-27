module "create_local_file" {

  # Wo liegt das Modul?
  source = "./modules/create_local_file"

  # Variablen für das Modul
  name_of_file    = "Datei_per_Modul.txt"
  content_of_file = "Hallo Modul!\n"
}
