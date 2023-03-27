module "Dateien" {
  source = "./modules/create_local_file"
  count  = 4

  name_of_file    = "Datei${count.index + 1}.txt"
  content_of_file = "Hallo Datei${count.index + 1}!\n"
}
