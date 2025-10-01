output "vpc_id" {
  description = "VPC ID - the 'deed' to our land"
  value       = aws_vpc.main.id
}

output "public_subnets" {
  description = "List of public subnet IDs - the 'addresses' of our entrances"
  value       = aws_subnet.public[*].id
}

output "private_subnets" {
  description = "List of private subnet IDs - the 'addresses' of our internal areas"
  value       = aws_subnet.private[*].id
}

output "vpc_cidr_block" {
  description = "VPC CIDR block - the 'boundary survey' of our land"
  value       = aws_vpc.main.cidr_block
}
