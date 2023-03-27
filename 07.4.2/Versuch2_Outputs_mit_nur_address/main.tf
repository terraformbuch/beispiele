module "webservers" {
  count  = 1
  source = "./modules/vm_with_port_and_floating_ip"

  instance_name_or_prefix = "webserver${count.index + 1}"
}

module "databases" {
  count  = 1
  source = "./modules/vm_with_port_and_floating_ip"

  instance_name_or_prefix = "database${count.index + 1}"
  instance_flavor_name    = "4C-4GB-20GB"
}

module "loadbalancers" {
  count  = 2
  source = "./modules/vm_with_port_and_floating_ip"

  instance_name_or_prefix = "loadbalancer${count.index + 1}"
  instance_flavor_name    = "4C-4GB-20GB"
}
