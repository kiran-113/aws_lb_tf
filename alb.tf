resource "aws_lb" "my_alb" {
  name               = "my-application-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public.id, aws_subnet.public-2.id]

  # enable_deletion_protection can prevent the ALB from being accidentally deleted
  enable_deletion_protection = false

  # Access logs can be useful for audit and debug purposes
  #  access_logs {
  #     bucket  = "my-alb-logs-bucket" # Replace with your S3 bucket name
  #     prefix  = "my-alb-logs"
  #     enabled = true
  #   }


  # Tags are essential for cost tracking, ownership, and other aspects of infrastructure management.
  tags = {
    Environment = "production"
  }
}

# ALB Target Group
resource "aws_lb_target_group" "alb_target_group" {
  name     = "my-alb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id

  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
  }
}

# ALB Listener
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}
