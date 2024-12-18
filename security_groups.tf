resource "aws_security_group" "alb_sg" {
  vpc_id      = aws_vpc.my_vpc.id
  name        = "alb-security-group"
  description = "ALB security group"

  # Typically you should restrict your ingress traffic. Here we allow all traffic.
  # Narrow this down to your actual IP ranges/ports depending on your use case.
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Define egress to allow ALB to communicate to the internet/outside
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "instance_sg" {
  name_prefix = "instance-sg"
  description = "Security Group for instances to allow traffic from ALB"
  vpc_id      = aws_vpc.my_vpc.id # Replace with your VPC ID

  # Allow all traffic from the ALB security group
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id] # ID of your ALB Security Group
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Standard outbound rule to allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
