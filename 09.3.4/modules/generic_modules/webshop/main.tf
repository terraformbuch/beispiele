variable "bucket_list" {}
variable "s3_count" {}
variable "vm_count" {}
variable "providers_enabled" {}

module "aws_webshop_socken" {
  source = "../../aws/webshop"
  count  = var.providers_enabled["aws"] ? 1 : 0

  bucket_list = var.bucket_list
  s3_count    = var.s3_count
  vm_count    = var.vm_count
}

module "azure_webshop_socken" {
  source = "../../azure/webshop"
  count  = var.providers_enabled["azure"] ? 1 : 0

  bucket_list = var.bucket_list
  s3_count    = var.s3_count
  vm_count    = var.vm_count
}

module "gcp_webshop_socken" {
  source = "../../gcp/webshop"
  count  = var.providers_enabled["gcp"] ? 1 : 0

  bucket_list = var.bucket_list
  s3_count    = var.s3_count
  vm_count    = var.vm_count
}