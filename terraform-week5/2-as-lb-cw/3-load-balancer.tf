resource "aws_security_group" "bl-sg" {
  vpc_id = var.from_previous_workflow_vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.anyone_access_ip] // if hope only me come, write my ip/32
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = [var.anyone_access_ip]
    prefix_list_ids = []
  }
  tags = {
    Name = "${var.week_prefix}-lb-sg"
  }
}


resource "aws_lb" "cyf-hotel-lb" {
  name               = "${var.week_prefix}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.bl-sg.id] # http 80
  subnets            = [var.from_previous_workflow_public_subnet_ids[*]]

  tags = {
    Name = "${var.week_prefix}-lb"
  }
}

resource "aws_lb_target_group" "lb-target-group" {
  name     = "4000-cyf-hotel"
  port     = 4000
  protocol = "HTTP"
  vpc_id   = var.from_previous_workflow_vpc_id
}

# resource "aws_lb_target_group_attachment" "lb-target-group-attachment" {
#   depends_on       = [aws_autoscaling_group.autoscaling-group]
#   target_group_arn = aws_lb_target_group.lb-target-group.arn
#   port             = 4000

#   for_each = { for idx, instance_id in data.aws_instances.autoscaling_instances.ids : idx => instance_id }

#   target_id = each.value

# }

resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = aws_lb.cyf-hotel-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb-target-group.arn
  }
}

output "lb-dns-name" {
  value = aws_lb.cyf-hotel-lb.dns_name
}
