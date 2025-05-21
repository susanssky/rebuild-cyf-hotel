resource "aws_security_group" "rds-sg" {
  vpc_id = aws_vpc.vpc.id
  name   = "${var.week_prefix}-rds-sg"
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    cidr_blocks     = [var.anyone_access_ip]
    security_groups = [aws_security_group.ec2-sg.id]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = [var.anyone_access_ip]
    prefix_list_ids = []
  }
  tags = {
    Name = "${var.week_prefix}-rds-sg"
  }
}

resource "aws_security_group" "ec2-sg" {
  vpc_id = aws_vpc.vpc.id
  name   = "${var.week_prefix}-ec2-sg"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.anyone_access_ip] // if hope only me come, write my ip/32
  }
  ingress {
    from_port   = 4000
    to_port     = 4000
    protocol    = "tcp"
    cidr_blocks = [var.anyone_access_ip]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = [var.anyone_access_ip]
    prefix_list_ids = []
  }
  tags = {
    Name = "${var.week_prefix}-ec2-sg"
  }
}

