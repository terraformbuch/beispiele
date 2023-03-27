variable "providers_enabled" {
  default = {
    "aws": false,
    "azure": false,
    "gcp": true,
  }
}

module "webshop_socken" {
  source = "./modules/generic_modules/webshop"

  bucket_list = [
    "Artikel-Bilder",
    "Website-Bilder"
  ]
  s3_count          = 5
  vm_count          = 21
  providers_enabled = var.providers_enabled
}
