
output "ec2_public_ip" { value = aws_instance.backend.public_ip }
output "ec2_id" { value = aws_instance.backend.id }


output "ec2_key_name" { value = aws_key_pair.ssh-key.key_name }
output "ec2_private_key" {
  value     = tls_private_key.create-key-pair-for-ec2.private_key_pem
  sensitive = true
}
# output "ec2_public_key" {
#   value     = tls_private_key.create-key-pair-for-ec2.public_key_openssh
#   sensitive = true
# }
