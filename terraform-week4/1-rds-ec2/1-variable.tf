
variable "week_prefix" {
  default = "cloud-week4"
}
variable "anyone_access_ip" {
  default = "0.0.0.0/0"
}

variable "vpc" {
  default = "10.0.0.0/16"
}

variable "subnet_number" {
  default = 2
}

data "aws_availability_zones" "available" {
  state = "available"
}

variable "database_username" {}
variable "database_password" {}

variable "ec2_public_key" {}
variable "docker_pw" {}

