# Data source to fetch the latest Ubuntu AMI ID
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_launch_template" "my_launch_template" {
  name_prefix   = "my-launch-template"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  # Specify the VPC security group and subnet for the network interface
  network_interfaces {
    security_groups = [aws_security_group.instance_sg.id]
    subnet_id       = aws_subnet.private.id
  }
  user_data = base64encode(<<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install nginx -y
              echo "This is instance has ths IP: $(curl http://169.254.169.254/latest/meta-data/local-ipv4)" | sudo tee /var/www/html/index.html
              EOF
  )
}



# Auto Scaling Group
resource "aws_autoscaling_group" "my_asg" {
  launch_template {
    id      = aws_launch_template.my_launch_template.id
    version = "$Latest"
  }

  min_size            = 1
  max_size            = 3
  desired_capacity    = 1
  vpc_zone_identifier = [aws_subnet.private.id, aws_subnet.public.id]

  target_group_arns = [aws_lb_target_group.alb_target_group.arn]
}
