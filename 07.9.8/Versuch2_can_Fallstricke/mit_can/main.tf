variable "flavor" {

  validation {
    condition     = can(contains(["1C-2GB-10GB", "2C-4GB-20GB", "4C-16GB-40GB"], var.flavor))
    error_message = "Flavor must be one of 1C-2GB-10GB, 2C-4GB-20GB or 4C-16GB-40GB"
  }
}
