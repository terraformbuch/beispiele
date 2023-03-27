module "sub_module" {
  source = "./sub_module"
}

output "root_module-path_root" {
  value = "path.root hat den Wert: ${path.root}"
}

output "root_module-path_module" {
  value = "path.module hat den Wert: ${path.module}"
}

output "root_module-path_cwd" {
  value = "path.cwd hat den Wert: ${path.cwd}"
}

output "sub_module-path_root" {
  value = "path.root hat den Wert: ${module.sub_module.sub_module-path_root}"
}

output "sub_module-path_module" {
  value = "path.module hat den Wert: ${module.sub_module.sub_module-path_module}"
}

output "sub_module-path_cwd" {
  value = "path.cwd hat den Wert: ${module.sub_module.sub_module-path_cwd}"
}
