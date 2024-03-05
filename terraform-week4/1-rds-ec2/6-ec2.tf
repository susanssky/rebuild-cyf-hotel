
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
  subnet_id                   = aws_subnet.public-subnet[0].id
  vpc_security_group_ids      = [aws_security_group.ec2-sg.id]
  availability_zone           = aws_subnet.public-subnet[0].availability_zone
  associate_public_ip_address = true
  user_data                   = <<EOF
#!/bin/bash
sudo apt update
sudo apt install stress -y
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
sudo chmod 666 /var/run/docker.sock
echo "${var.docker_pw}" | sudo docker login --username susanssky --password-stdin
EOF

  tags = {
    Name = "${var.week_prefix}-ec2"
  }
}

# This resource will destroy (potentially immediately) after null_resource.next
resource "null_resource" "previous" {}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [null_resource.previous]

  create_duration = "120s"
}

# This resource will create (at least) 30 seconds after null_resource.previous
resource "null_resource" "next" {
  depends_on = [time_sleep.wait_30_seconds]
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

