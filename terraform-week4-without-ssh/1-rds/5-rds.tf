resource "aws_db_subnet_group" "subnet-group" {
  name       = "${var.week_prefix}-rds-subnet-group"
  subnet_ids = aws_subnet.private-subnet[*].id
  tags = {
    Name = "${var.week_prefix}-rds-subnet-group"
  }
}

resource "aws_db_parameter_group" "parameter-group" {
  name   = "${var.week_prefix}-rds-parameter-group"
  family = "postgres16"
  tags = {
    Name = "${var.week_prefix}-rds-parameter-group"
  }
}

resource "aws_db_instance" "database" {
  db_subnet_group_name     = aws_db_subnet_group.subnet-group.id
  vpc_security_group_ids   = [aws_security_group.rds_sg.id]
  allocated_storage        = 20
  identifier               = "${var.week_prefix}-hotel-db"
  engine                   = "postgres"
  engine_version           = "16.3"
  instance_class           = "db.t3.micro"
  username                 = var.database_username
  password                 = var.database_password
  publicly_accessible      = false
  delete_automated_backups = false
  multi_az                 = false
  parameter_group_name     = aws_db_parameter_group.parameter-group.name
  availability_zone        = data.aws_availability_zones.available.names[0]
  skip_final_snapshot      = true
  tags = {
    Name = "${var.week_prefix}-rds"
  }
}
