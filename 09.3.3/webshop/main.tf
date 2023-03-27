variable "bucket_list" {}
variable "s3_count" {}
variable "vm_count" {}

module "keypair" {
  source = "modules/keypair"
}

module "vm" {
  count  = var.vm_count
  source = "modules/vm"
}

module "s3" {
  count  = var.s3_count
  source = "module/s3"
}

module "bucket" {
  count  = length(var.bucket_list)
  source = "modules/bucket"

  name = element(var.bucket_list, count.index)
}
