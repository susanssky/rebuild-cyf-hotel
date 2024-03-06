resource "aws_ami_from_instance" "create-image" {
  name               = "${var.week_prefix}-ec2-image"
  source_instance_id = var.from_previous_workflow_ec2_id
}

resource "aws_launch_template" "ec2-template" {
  image_id      = aws_ami_from_instance.create-image.id
  instance_type = "t2.micro"
  key_name      = var.from_previous_workflow_key_name

  # monitoring {
  #   enabled = true
  # }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.from_previous_workflow_aws_security_group_id]
  }

  tags = {
    Name = "${var.week_prefix}-template"
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.week_prefix}-auto-scaling"
    }
  }

}

resource "aws_autoscaling_group" "autoscaling-group" {
  vpc_zone_identifier = [for id in aws_subnet.private-subnet[*].id : id]
  desired_capacity    = 1
  min_size            = 1
  max_size            = 3
  force_delete        = true
  target_group_arns   = aws_lb_target_group.lb-target-group[*].arn

  launch_template {
    id      = aws_launch_template.ec2-template.id
    version = "$Latest"
  }
}
resource "aws_autoscaling_policy" "autoscaling-policy" {
  name        = "${var.week_prefix}-scaling-target-tracking-policy"
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 70.0
  }
  autoscaling_group_name = aws_autoscaling_group.autoscaling-group.name
}
