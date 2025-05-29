resource "aws_cloudwatch_metric_alarm" "rds-write-alarm" {
  alarm_name          = "rds-write-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "WriteThroughput"
  namespace           = "AWS/RDS"
  period              = 60
  statistic           = "Average"
  threshold           = 10000
  tags = {
    Name = "${var.week_prefix}-rds-write-alarm"
  }
}

resource "aws_cloudwatch_metric_alarm" "rds-read-alarm" {
  alarm_name          = "rds-read-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ReadThroughput"
  namespace           = "AWS/RDS"
  period              = 60
  statistic           = "Average"
  threshold           = 10000
  tags = {
    Name = "${var.week_prefix}-rds-read-alarm"
  }
}
