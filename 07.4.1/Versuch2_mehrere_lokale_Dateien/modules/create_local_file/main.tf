resource "local_file" "lokale_Datei" {
  content  = var.content_of_file
  filename = var.name_of_file
}
