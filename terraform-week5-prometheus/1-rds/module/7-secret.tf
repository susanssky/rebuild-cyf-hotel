resource "aws_secretsmanager_secret" "rds_credentials" {
  name = "${var.week_prefix}-rds-credentials"

  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "rds_credentials_version" {
  secret_id = aws_secretsmanager_secret.rds_credentials.id
  secret_string = jsonencode({
    endpoint = aws_db_instance.database.endpoint
    username = aws_db_instance.database.username
    password = aws_db_instance.database.password
  })
}

