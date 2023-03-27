variable "all_vm_specs" {
  description = "single variable that holds all information for multiple virtual machines"
  type = list(
    object({
      name   = string
      count  = optional(number)
      flavor = optional(string, "1C-2GB-10GB")
      image  = optional(string, "Ubuntu 22.04")
    })
  )

  validation {
    condition = alltrue([
      for entry in var.all_vm_specs : (
        contains(["1C-2GB-10GB", "2C-4GB-20GB", "4C-16GB-40GB"], entry.flavor)
      )
    ])
    error_message = "No valid flavor defined. Valid options are 1C-2GB-10GB, 2C-4GB-20GB or 4C-16GB-40GB"
  }
  validation {
    condition = alltrue([
      for entry in var.all_vm_specs : (
        contains(["Ubuntu 20.04", "Ubuntu 22.04", "SLES 15"], entry.image)
      )
    ])
    error_message = "No valid image defined. Valid options are Ubuntu 20.04, Ubuntu 22.04 or SLES 15"
  }
}
