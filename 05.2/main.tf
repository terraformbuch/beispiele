resource "local_file" "beispiel_datei" {
  content  = "Hello, world!"
  filename = "./beispiel.txt"
}
