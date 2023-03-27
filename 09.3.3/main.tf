module "webshop_socken" {
  source = "./webshop"

  bucket_list = [
    "Artikel-Bilder",
    "Website-Bilder"
  ]
  s3_count = 5
  vm_count = 21
}

module "webshop_baumarkt" {
  source = "./webshop"

  bucket_list = [
    "Website-Bilder",
    "Baustoffe-Bilder",
    "Eisenwaren-Bilder",
    "Werkzeuge-Bilder",
    "Holz-Bilder",
    "Floristik-Bilder",
    "Garten-Bilder",
    "Elektrik-Bilder",
    "Lampen-Bilder",
    "Farbe-Bilder",
    "Kleinteile-Bilder",
    "Mietgeräte-Bilder",
  ]
  s3_count = 50
  vm_count = 2100
}
