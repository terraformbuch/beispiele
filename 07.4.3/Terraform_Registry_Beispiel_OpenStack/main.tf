# kopiert von https://registry.terraform.io/modules/haxorof/security-group/openstack/latest

module "security-group" {
  source  = "haxorof/security-group/openstack"
  version = "0.3.0"
  # insert the 1 required variable here
  name    = "tfbk-test"
}
