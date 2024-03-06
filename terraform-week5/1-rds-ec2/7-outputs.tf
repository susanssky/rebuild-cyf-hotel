output "vpc_id" { value = aws_vpc.vpc.id }
output "public_subnet_id" { value = aws_subnet.public-subnet[*].id }
# output "private_subnet_id" { value = aws_subnet.private-subnet[*].id }

output "rds_identifier" { value = aws_db_instance.database.identifier } # for cloudwatch dashboard
output "rds_endpoint" { value = aws_db_instance.database.endpoint }
output "rds_security_group_id" { value = aws_security_group.rds-sg.id }

output "ec2_public_ip" { value = aws_instance.backend.public_ip }
output "ec2_id" { value = aws_instance.backend.id }
output "ec2_security_group_id" { value = aws_security_group.ec2-sg.id }

output "key_name" { value = aws_key_pair.ssh-key.key_name }
# output "ec2_private_key" {
#   value     = tls_private_key.create-key-pair-for-ec2.private_key_pem
#   sensitive = true
# }
# output "ec2_public_key" {
#   value     = tls_private_key.create-key-pair-for-ec2.public_key_openssh
#   sensitive = true
# }
