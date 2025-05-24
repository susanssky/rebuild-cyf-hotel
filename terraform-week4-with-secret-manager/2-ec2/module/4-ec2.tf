resource "aws_key_pair" "ssh_key" {
  key_name   = "tf-aws-ec2-key"
  public_key = var.ec2_public_key
}


resource "aws_instance" "backend" {
  ami                         = "ami-0505148b3591e4c07" //hard code because "data" can not filter free tier ami Ubuntu Server 22.04 LTS (HVM), SSD Volume Type (64-bit (x86))
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.ssh_key.key_name
  subnet_id                   = aws_subnet.public_subnet[0].id
  iam_instance_profile        = aws_iam_instance_profile.access_secret_manager.name
  vpc_security_group_ids      = [var.ec2_sg_id]
  availability_zone           = aws_subnet.public_subnet[0].availability_zone
  associate_public_ip_address = true

  tags = {
    Name = "${var.week_prefix}-ec2"
  }
}


