variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "admin_cidr_blocks" {
  description = "CIDR blocks allowed for SSH/admin access"
  type        = list(string)
  default     = []
}

variable "enable_ssh_access" {
  description = "Whether to enable SSH access from admin networks"
  type        = bool
  default     = false
}
