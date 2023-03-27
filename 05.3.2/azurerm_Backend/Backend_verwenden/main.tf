terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
  backend "azurerm" {
      resource_group_name  = "tfstate"
      # bitte passen Sie den Namen des storage account an
      storage_account_name = "tfstate01234abcde"
      container_name       = "tfstate"
      key                  = "terraform.tfstate"
  }
}

resource "local_file" "Beispieldatei" {
  content  = "Terraform ist toll\n"
  filename = "./Beispieldatei.txt"
}
