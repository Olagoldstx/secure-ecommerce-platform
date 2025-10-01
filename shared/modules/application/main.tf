# Launch Template for application servers
resource "aws_launch_template" "app" {
  name          = "${var.environment}-app-template"
  image_id      = "ami-0fc5d935ebf8bc3bc"  # Ubuntu 22.04
  instance_type = var.instance_type

  vpc_security_group_ids = [var.security_group_id]
  
  iam_instance_profile {
    name = var.instance_profile_name
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y nginx
    systemctl start nginx
    systemctl enable nginx
    echo "<h1>Secure E-Commerce Application</h1>" > /var/www/html/index.html
  EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "${var.environment}-app-server"
      Environment = var.environment
    }
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "app" {
  name                = "${var.environment}-app-asg"
  vpc_zone_identifier = var.private_subnets
  desired_capacity    = 1
  min_size           = 1
  max_size           = 2

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  target_group_arns = [var.target_group_arn]

  tag {
    key                 = "Name"
    value               = "${var.environment}-app-instance"
    propagate_at_launch = true
  }
}
