terraform {
  required_version = ">= 1.3.6"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.39.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "4.39.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4.3"
    }
  }
}
