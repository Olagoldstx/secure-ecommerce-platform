# Database Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = var.private_subnets

  tags = {
    Name        = "${var.environment}-db-subnet-group"
    Environment = var.environment
  }
}

# RDS PostgreSQL Database
resource "aws_db_instance" "main" {
  identifier             = "${var.environment}-ecommerce-db"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "14.9"
  username               = var.db_username
  password               = "TempPassword123!"
  db_name                = var.db_name
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.security_group_id]
  skip_final_snapshot    = true
  publicly_accessible    = false

  tags = {
    Name        = "${var.environment}-ecommerce-db"
    Environment = var.environment
  }
}
