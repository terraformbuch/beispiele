module "variable_with_validations" {
  source = "./submodule"

  all_vm_specs = [
    {
      name   = "webserver"
      flavor = "1C-2GB-10GB"
      image  = "Ubuntu 22.04"
    },
    {
      name   = "database"
      flavor = "2C-4GB-20GB"
      image  = "Ubuntu 22.04"
    }
  ]
}
