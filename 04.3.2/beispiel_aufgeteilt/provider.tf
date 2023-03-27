provider "google" {
  credentials = pathexpand("~/.config/gcloud/application_default_credentials.json")
  project     = "terraform-buch"
  region      = "europe-west3"
  zone        = "europe-west3-b"
}
