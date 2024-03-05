resource "aws_db_subnet_group" "subnet-group" {
  # for RDS
  subnet_ids = [aws_subnet.private-subnet[*].id]
  tags = {
    Name = "${var.week_prefix}-rds-subnet-group"
  }
}
resource "aws_db_parameter_group" "parameter-group" {
  name   = "${var.week_prefix}-rds-parameter-group"
  family = "postgres15"
  tags = {
    Name = "${var.week_prefix}-rds-parameter-group"
  }
}

resource "aws_db_instance" "database" {
  db_subnet_group_name     = aws_db_subnet_group.subnet-group.id //If unspecified, will be created in the default VPC, or in EC2 Classic
  vpc_security_group_ids   = [aws_security_group.rds-sg.id]
  allocated_storage        = 20
  identifier               = "${var.week_prefix}-hotel-db"
  engine                   = "postgres"
  engine_version           = 15.4
  instance_class           = "db.t3.micro"
  username                 = var.database_username
  password                 = var.database_username
  port                     = 5432
  publicly_accessible      = false
  delete_automated_backups = false
  multi_az                 = false
  parameter_group_name     = aws_db_parameter_group.parameter-group.name
  # parameter_group_name = "default.postgres15"
  availability_zone   = data.aws_availability_zones.available.names[0]
  skip_final_snapshot = true //Determines if a snapshot should be taken before deleting the database. The database can be created without setting this setting. However, while destroying this database instance using Terraform, if this value is not set to true, the database is not destroyed.
  tags = {
    Name = "${var.week_prefix}-rds"
  }
}
# data "aws_db_instance" "current_rds" {
#   db_instance_identifier = "cyf-hotel-customers-db-cloud-week4"
# }
# output "rds_endpoint" {
#   value = data.aws_db_instance.current_rds.endpoint
# }
