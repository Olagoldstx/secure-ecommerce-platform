output "db_endpoint" {
  description = "Database endpoint"
  value       = aws_db_instance.main.endpoint
}
