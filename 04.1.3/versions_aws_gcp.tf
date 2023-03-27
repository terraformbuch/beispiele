terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
  }
}
