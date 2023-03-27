terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
  backend "s3" {
    # bitte passen Sie den bucket-Namen an
    bucket         = "tf-remote-state20221017124401021700000002"
    key            = "some_environment/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    # bitte passen Sie die kms_key_id an
    kms_key_id     = "12345678-aaaa-bbbb-cccc-1234567890"
    # bitte passen Sie die dynamodb_table an
    dynamodb_table = "tf-remote-state-lock"
  }
}

resource "local_file" "Beispieldatei" {
  content  = "Terraform ist toll\n"
  filename = "./Beispieldatei.txt"
}
