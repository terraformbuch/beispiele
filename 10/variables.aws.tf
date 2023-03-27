variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "aws_azs" {
  type    = list(any)
  default = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

variable "aws_os_image" {
  description = "Name of the OS image."
  type        = string
  default     = "ami-05039263dcd5a4285"
}

variable "aws_os_size" {
  description = "Name of the aws flavor."
  type        = string
  default     = "t2.micro"
}
