output "load_balancer_sg_id" {
  description = "Security group ID for load balancer - 'entrance security team'"
  value       = aws_security_group.load_balancer.id
}

output "application_sg_id" {
  description = "Security group ID for application servers - 'store security team'"
  value       = aws_security_group.application.id
}

output "database_sg_id" {
  description = "Security group ID for database servers - 'stockroom security team'"
  value       = aws_security_group.database.id
}

output "security_group_ids" {
  description = "Map of all security group IDs for reference"
  value = {
    load_balancer = aws_security_group.load_balancer.id
    application   = aws_security_group.application.id
    database      = aws_security_group.database.id
  }
}
