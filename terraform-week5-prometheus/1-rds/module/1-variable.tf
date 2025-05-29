
variable "week_prefix" {

}

variable "anyone_access_ip" {

}

variable "vpc_cidr" {

}

variable "subnet_number" {

}

data "aws_availability_zones" "available" {
  state = "available"
}


variable "database_username" {}
variable "database_password" {}




