output "rds_endpoint" { value = aws_db_instance.database.endpoint }
output "ec2_public_ip" { value = aws_instance.backend.public_ip }
output "ec2_id" { value = aws_instance.backend.id }

output "key_name" { value = aws_key_pair.ssh-key.key_name }
output "security_group_id" { value = aws_security_group.sg.id }
output "vpc_id" { value = aws_vpc.vpc.id }
output "subnet1_id" { value = aws_subnet.subnet1.id }
output "subnet2_id" { value = aws_subnet.subnet2.id }
