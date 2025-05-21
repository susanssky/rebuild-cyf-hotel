output "rds_endpoint" {
  value     = aws_db_instance.database.endpoint
  sensitive = true
}

output "vpc_id" {
  value     = aws_vpc.vpc.id
  sensitive = true
}

output "ec2_sg_id" {
  value     = aws_security_group.ec2_sg.id
  sensitive = true
}