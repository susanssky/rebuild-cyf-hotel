output "secret_manager_arn" {
  value = aws_secretsmanager_secret.rds_credentials.arn

}


output "ec2_sg_id" {
  value = aws_security_group.ec2_sg.id

}

