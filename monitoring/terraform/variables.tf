# Project Configuration
variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "fastapi-monitoring"
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

# EC2 Configuration
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "key_pair_name" {
  description = "Name of the EC2 Key Pair for SSH access"
  type        = string
  default     = "default"
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access monitoring services"
  type        = list(string)
  default     = ["0.0.0.0/0"] # WARNING: Restrict this in production
}
