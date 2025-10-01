output "ec2_instance_profile_name" {
  description = "IAM instance profile name for EC2 instances"
  value       = aws_iam_instance_profile.ec2_instance.name
}

output "ec2_instance_role_arn" {
  description = "IAM role ARN for EC2 instances"
  value       = aws_iam_role.ec2_instance_role.arn
}
