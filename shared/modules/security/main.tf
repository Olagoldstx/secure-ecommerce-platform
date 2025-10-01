# Load Balancer Security Group - "Main entrance security"
resource "aws_security_group" "load_balancer" {
  name        = "${var.environment}-load-balancer-sg"
  description = "Security group for application load balancer"
  vpc_id      = var.vpc_id

  # Allow HTTP from anywhere - "Customers can enter through main doors"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP traffic from internet"
  }

  # Allow HTTPS from anywhere - "Secure customer entrance"
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS traffic from internet"
  }

  # Allow all outbound traffic - "Customers can leave freely"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name        = "${var.environment}-load-balancer-sg"
    Environment = var.environment
    Team        = "security"
    Purpose     = "load-balancer"
  }
}

# Application Security Group - "Store interior security"
resource "aws_security_group" "application" {
  name        = "${var.environment}-application-sg"
  description = "Security group for application servers"
  vpc_id      = var.vpc_id

  # Allow HTTP from Load Balancer only - "Only let people from the entrance area into stores"
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.load_balancer.id]
    description     = "Allow HTTP from load balancer"
  }

  # Allow SSH from specific IPs only - "Manager access from office only"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.admin_cidr_blocks
    description = "Allow SSH from admin networks"
  }

  # Allow all outbound traffic - "Store can order supplies, call headquarters, etc."
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name        = "${var.environment}-application-sg"
    Environment = var.environment
    Team        = "security"
    Purpose     = "application"
  }
}

# Database Security Group - "Stockroom security - most restricted"
resource "aws_security_group" "database" {
  name        = "${var.environment}-database-sg"
  description = "Security group for database servers"
  vpc_id      = var.vpc_id

  # Allow PostgreSQL from Application Servers only - "Only store staff can access stockroom"
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.application.id]
    description     = "Allow PostgreSQL from application servers"
  }

  # Allow all outbound traffic - "Database can make external calls if needed"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name        = "${var.environment}-database-sg"
    Environment = var.environment
    Team        = "security"
    Purpose     = "database"
  }
}
