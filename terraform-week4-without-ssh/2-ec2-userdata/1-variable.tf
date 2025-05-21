variable "week_prefix" {
  default = "cloud-week4"
}

variable "anyone_access_ip" {
  default = "0.0.0.0/0"
}


variable "subnet_number" {
  default = 2
}

data "aws_availability_zones" "available" {
  state = "available"
}

variable "vpc_id" {}

variable "ec2_sg_id" {}

variable "database_username" {}

variable "database_password" {}

variable "database_endpoint" {}

variable "current_repo_name" {}

locals {
  git_repository = "https://github.com/susanssky/${var.current_repo_name}.git"
}
