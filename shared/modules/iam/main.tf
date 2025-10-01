# EC2 Instance Role - "Employee badge for application servers"
resource "aws_iam_role" "ec2_instance_role" {
  name = "${var.environment}-ec2-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Environment = var.environment
    Team        = "security"
    Purpose     = "ec2-instances"
  }
}

# Least Privilege Policy - "What employees are actually allowed to do"
resource "aws_iam_role_policy" "ec2_minimal" {
  name = "${var.environment}-ec2-minimal-permissions"
  role = aws_iam_role.ec2_instance_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = [
          "arn:aws:s3:::${var.environment}-ecommerce-logs/*",
          "arn:aws:s3:::${var.environment}-ecommerce-uploads/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

# Instance Profile - "The actual badge employees wear"
resource "aws_iam_instance_profile" "ec2_instance" {
  name = "${var.environment}-ec2-instance-profile"
  role = aws_iam_role.ec2_instance_role.name

  tags = {
    Environment = var.environment
    Team        = "security"
  }
}
