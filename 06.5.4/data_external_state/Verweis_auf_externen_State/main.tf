data "terraform_remote_state" "storage_cluster" {
  backend = "local"

  config = {
    path = "../storage_cluster/terraform.tfstate"
  }
}

locals {
  storage_servers = data.terraform_remote_state.storage_cluster.outputs.storage_server_ips
}

output "list_of_storage_servers" {
  value = local.storage_servers
}
