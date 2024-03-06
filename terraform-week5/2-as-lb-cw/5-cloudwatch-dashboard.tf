
data "aws_instances" "auto_scaling_ec2" {
  instance_tags = {
    Name = "${var.week_prefix}-auto-scaling"
  }

  instance_state_names = ["running"]
  # instance_state_names = ["running", "stopped"]
}

output "ec2-as-ids" {
  value = data.aws_instances.auto_scaling_ec2.ids
}
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "my-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      # {
      #   type   = "metric"
      #   x      = 0
      #   y      = 0
      #   width  = 12
      #   height = 6

      #   properties = {
      #     metrics = [
      #       for instance_id in data.aws_instances.auto_scaling_ec2.ids : [
      #         "AWS/EC2",
      #         "CPUUtilization",
      #         "InstanceId",
      #         instance_id
      #       ]
      #     ]

      #     period = 300
      #     stat   = "Average"
      #     region = "eu-west-2"
      #     title  = "EC2 Instance CPU"
      #   }
      # },
      # {
      #   type   = "text"
      #   x      = 0
      #   y      = 7
      #   width  = 3
      #   height = 3
      #   properties = {
      #     markdown = "Hello world"
      #   }
      # },
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/RDS",
              "ReadThroughput",
              "DBInstanceIdentifier",
              var.from_previous_workflow_rds_identifier
            ]
          ]
          period = 300
          stat   = "Average"
          region = "eu-west-2"
          title  = "RDS ReadThroughput"
        }
      },
      # {
      #   type   = "metric"
      #   x      = 0
      #   y      = 0
      #   width  = 12
      #   height = 6

      #   properties = {
      #     metrics = [
      #       [
      #         "AWS/RDS",
      #         "WriteThroughput",
      #         "DBInstanceIdentifier",
      #         var.from_previous_workflow_rds_identifier
      #       ]
      #     ]
      #     period = 300
      #     stat   = "Average"
      #     region = "eu-west-2"
      #     title  = "RDS WriteThroughput"
      #   }
      # },
    ],
  })
}
