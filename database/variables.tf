# AWS provider configuration
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "arn_aws_lab_role" {
  description = "ARN for the IAM role"
  type        = string
}

# VPC configuration
variable "vpc_id" {
  description = "VPC ID - VPC Created in the infrastructure repo"
  type        = string
}

variable "subnet_database_1_cidr_block" {
  description = "CIDR block for the database subnet"
  type        = string
  default     = "10.0.5.0/24"
}

variable "subnet_database_2_cidr_block" {
  description = "CIDR block for the database subnet"
  type        = string
  default     = "10.0.6.0/24"
}

variable "subnet_availability_zone_az_1" {
  description = "Availability zone for the subnets"
  type        = string
}

variable "subnet_availability_zone_az_2" {
  description = "Availability zone 2 for the subnets"
  type        = string
}

# Database configuration
variable "db_username" {
  description = "The username for the RDS instance"
  type        = string
  sensitive   = true
  default     = "videodbuser"
}

variable "db_password" {
  description = "The password for the RDS instance"
  type        = string
  sensitive   = true
  default     = "videodbpass"
}

variable "db_name" {
  description = "Security Group ID for the Lambda"
  type        = string
  default     = "videodb"
}

variable "db_identifier" {
  description = "The identifier for the RDS instance"
  type        = string
  default     = "video-db"
}

# EKS configuration
variable "cluster_sg_id" {
  description = "Security Group ID for the EKS Cluster"
  type        = string
}
