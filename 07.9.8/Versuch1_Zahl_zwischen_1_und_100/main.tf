variable "seed_number" {
  description = "Geben Sie eine Zahl zwischen 1 und 100 ein."
  type        = number

  validation {
    condition     = regex("^[1-9][0-9]?$|^100$", var.seed_number)
    error_message = "Die eingegebene Zahl liegt nicht zwischen 1 und 100!"
  }
}
