resource "tls_private_key" "create-key-pair-for-ec2" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh-key" {
  key_name   = "tf-aws-ec2-key"
  public_key = tls_private_key.create-key-pair-for-ec2.public_key_openssh
}
resource "aws_instance" "backend" {
  ami                         = "ami-0505148b3591e4c07" //hard code because "data" can not filter free tier ami Ubuntu Server 22.04 LTS (HVM), SSD Volume Type (64-bit (x86))
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.ssh-key.key_name
  subnet_id                   = aws_subnet.public_subnet[0].id
  vpc_security_group_ids      = [var.ec2_sg_id]
  availability_zone           = aws_subnet.public_subnet[0].availability_zone
  associate_public_ip_address = true
  user_data                   = <<EOF
#!/bin/bash
sudo apt update
sudo apt install -y postgresql docker.io git
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
sudo apt install -y docker-compose-v2
sudo chmod 666 /var/run/docker.sock

git clone ${local.git_repository} /home/ubuntu/${var.current_repo_name}
sudo -u postgres -i psql postgresql://${var.database_username}:${var.database_password}@${var.database_endpoint} < /home/ubuntu/database/seeding.sql
mv /home/ubuntu/${var.current_repo_name}/docker-compose-week4.yaml /home/ubuntu/docker-compose-week4.yaml
rm -rf /home/ubuntu/${var.current_repo_name}

echo "SERVER_PORT=4000" > /home/ubuntu/.env
echo "DATABASE_URL=postgres://${var.database_username}:${var.database_password}@${var.database_endpoint}/postgres" >> /home/ubuntu/.env
docker compose -f /home/ubuntu/docker-compose-week4.yaml pull
docker compose -f /home/ubuntu/docker-compose-week4.yaml up -d
docker image prune -a -f
EOF
  tags = {
    Name = "${var.week_prefix}-ec2"
  }
}


# if you want to get the NEWEST value, 
# please use data+output instead of output
# data "aws_instance" "current_ec2" {
#   instance_id = aws_instance.backend.id
# }
# output "ec2_public_ip" {
#   value = data.aws_instance.current_ec2.public_ip
# }
# output "ec2_id" {
#   value = data.aws_instance.current_ec2.id
# }
# output "ec2_state" {
#   value = data.aws_instance.current_ec2.instance_state
# }
# output "ec2_public_ip" {
#   value = aws_instance.backend.public_ip
# }

