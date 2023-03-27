provider "google" {
  credentials = pathexpand("~/.config/gcloud/application_default_credentials.json")
  project     = "terraform-buch"
}
