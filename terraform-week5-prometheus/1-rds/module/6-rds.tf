resource "aws_db_subnet_group" "subnet_group" {
  name       = "${var.week_prefix}-rds-subnet-group"
  subnet_ids = aws_subnet.private_subnet[*].id
  tags = {
    Name = "${var.week_prefix}-rds-subnet-group"
  }
}

resource "aws_db_parameter_group" "parameter_group" {
  name   = "${var.week_prefix}-rds-parameter-group"
  family = "postgres17"

  tags = {
    Name = "${var.week_prefix}-rds-parameter-group"
  }
}

resource "aws_db_instance" "database" {
  db_subnet_group_name            = aws_db_subnet_group.subnet_group.id
  vpc_security_group_ids          = [aws_security_group.rds_sg.id]
  allocated_storage               = 20
  identifier                      = "${var.week_prefix}-hotel-db"
  engine                          = "postgres"
  engine_version                  = "17.3"
  instance_class                  = "db.t3.micro"
  username                        = var.database_username
  password                        = var.database_password
  publicly_accessible             = false
  delete_automated_backups        = false
  multi_az                        = false
  parameter_group_name            = aws_db_parameter_group.parameter_group.name
  availability_zone               = data.aws_availability_zones.available.names[0]
  skip_final_snapshot             = true
  auto_minor_version_upgrade      = false
  tags = {
    Name = "${var.week_prefix}-rds"
  }
}

