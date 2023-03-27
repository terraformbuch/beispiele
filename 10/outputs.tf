output "root_password" {
  value     = random_password.root_password.result
  sensitive = true
}

output "admin_user" {
  value = var.admin_user
}

output "private_key" {
  value = var.private_key
}

output "libvirt_ipaddress" {
  value = var.libvirt_enabled ? module.libvirt.ipaddress : ""
}

output "openstack_ipaddress" {
  value = var.openstack_enabled ? module.openstack.0.ipaddress : ""
}

output "openstack_ipaddress_bastion" {
  value = var.openstack_enabled ? module.openstack.0.ipaddress_bastion : ""
}

output "openstack_ipaddress_loadbalancer" {
  value = var.openstack_enabled ? module.openstack.0.ipaddress_loadbalancer : ""
}

output "azure_ipaddress" {
  value = var.azure_enabled ? module.azure.0.ipaddress : ""
}

output "azure_ipaddress_bastion" {
  value = var.azure_enabled ? module.azure.0.ipaddress_bastion : ""
}

output "azure_ipaddress_loadbalancer" {
  value = var.azure_enabled ? module.azure.0.ipaddress_loadbalancer : ""
}

output "azure_admin_password" {
  value     = var.azure_enabled ? module.azure.0.admin_password : ""
  sensitive = true
}

output "aws_ipaddress" {
  value = var.aws_enabled ? module.aws.0.ipaddress : ""
}

output "aws_ipaddress_bastion" {
  value = var.aws_enabled ? module.aws.0.ipaddress_bastion : ""
}

output "aws_ipaddress_loadbalancer" {
  value = var.aws_enabled ? module.aws.0.ipaddress_loadbalancer : ""
}

output "gcp_ipaddress" {
  value = var.gcp_enabled ? module.gcp.0.ipaddress : ""
}

output "gcp_ipaddress_bastion" {
  value = var.gcp_enabled ? module.gcp.0.ipaddress_bastion : ""
}

output "gcp_ipaddress_loadbalancer" {
  value = var.gcp_enabled ? module.gcp.0.ipaddress_loadbalancer : ""
}

output "gcp_ipaddress" {
  value = var.gcp_enabled ? module.gcp.0.ipaddress : ""
}

output "gcp_ipaddress_bastion" {
  value = var.gcp_enabled ? module.gcp.0.ipaddress_bastion : ""
}

output "gcp_ipaddress_loadbalancer" {
  value = var.gcp_enabled ? module.gcp.0.ipaddress_loadbalancer : ""
}

output "vmware_ipaddress" {
  value = var.vmware_enabled ? module.vmware.0.ipaddress : ""
}

## uncomment if you want to use vspehre/vmware
# Leider ist es aktuell nicht möglich den vspere Provider einfach zu deaktivieren. Daher müssen, falls das `vmware` Modul genutzt werden soll, in _main.tf_ und _outputs.tf_ einige `vmware`-Modul spezifische Zeilen einkommentiert werden.
#output "vmware_ipaddress" {
#  value = var.vmware_enabled ? module.vmware.0.ipaddress : ""
#}
