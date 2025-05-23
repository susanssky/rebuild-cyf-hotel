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


variable "ec2_sg_id" {}

variable "ec2_public_key" {}