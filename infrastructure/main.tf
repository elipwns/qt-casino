# Qt Casino - AWS Infrastructure
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Variables
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

# RDS Database (PostgreSQL)
resource "aws_db_instance" "casino_db" {
  identifier = "qt-casino-${var.environment}"
  
  # Minimal setup for development
  engine         = "postgres"
  engine_version = "15.4"
  instance_class = "db.t3.micro"  # ~$13/month
  
  allocated_storage = 20
  storage_type      = "gp2"
  storage_encrypted = true
  
  db_name  = "qtcasino"
  username = "casino_admin"
  password = var.db_password
  
  backup_retention_period = 7
  skip_final_snapshot     = true  # For dev
  deletion_protection     = false # For dev
  
  tags = {
    Name = "qt-casino-db"
  }
}

# ElastiCache Redis for real-time game state
resource "aws_elasticache_replication_group" "casino_redis" {
  replication_group_id = "qt-casino-${var.environment}"
  description          = "Redis for Qt Casino game state"
  
  node_type            = "cache.t3.micro"  # ~$15/month
  port                 = 6379
  num_cache_clusters   = 1
  
  at_rest_encryption_enabled = true
  
  tags = {
    Name = "qt-casino-redis"
  }
}

# ECS Cluster for game servers
resource "aws_ecs_cluster" "casino_cluster" {
  name = "qt-casino-${var.environment}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "qt-casino-cluster"
  }
}

# Outputs
output "database_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.casino_db.endpoint
  sensitive   = true
}

output "redis_endpoint" {
  description = "ElastiCache Redis endpoint"
  value       = aws_elasticache_replication_group.casino_redis.primary_endpoint_address
  sensitive   = true
}