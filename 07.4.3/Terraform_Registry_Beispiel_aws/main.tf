# kopiert von https://registry.terraform.io/modules/terraform-aws-modules/key-pair/aws/latest

module "key-pair" {
  source   = "terraform-aws-modules/key-pair/aws"
  version  = "1.0.0"
  # insert the 2 required variables here
  key_name = "tfbk-test"
}
