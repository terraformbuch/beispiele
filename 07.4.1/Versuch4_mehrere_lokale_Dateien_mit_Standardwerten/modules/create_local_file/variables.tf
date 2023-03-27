variable "name_of_file" {
  type        = string
  description = "Name of the file"
}

variable "content_of_file" {
  type        = string
  description = "Content of the file"
}

variable "file_permissions" {
  type        = string
  description = "Permissions of the file"
  default     = "0644"
}
