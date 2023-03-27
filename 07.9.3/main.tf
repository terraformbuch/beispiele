variable "relative_file_path" {
  default = "./archive.xz"
}
output "absolute_file_path" {
  value = abspath(var.relative_file_path)
}
