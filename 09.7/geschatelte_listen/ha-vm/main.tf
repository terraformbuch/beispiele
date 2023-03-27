resource "x_cloud.virtual_machine" "vmpair" {
  count = 2
  name  = "vm_paar"
}

output "ips" {
  value = x_cloud.virtual_machine.vmpair[*].ip
}
