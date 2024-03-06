
variable "week_prefix" {
  default = "cloud-week5"
}
variable "anyone_access_ip" {
  default = "0.0.0.0/0"
}


################
# workflow variable from previous workflow
variable "from_previous_workflow_vpc_id" {}
variable "from_previous_workflow_public_subnet_ids" {
  type = list(string)
}
variable "from_previous_workflow_rds_identifier" {}
variable "from_previous_workflow_ec2_id" {}
variable "from_previous_workflow_ec2_security_group_id" {}
variable "from_previous_workflow_ec2_key_name" {}
