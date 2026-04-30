# Simple S3 bucket to demonstrate GitHub Actions automation
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

variable "bucket_suffix" {
  description = "Unique suffix for bucket name (use your initials)"
  type        = string
  default     = "sao"  # CHANGED THIS to my initials!
}

# S3 Bucket - using fixed name to prevent duplicates
resource "aws_s3_bucket" "demo" {
  bucket = "cloudburst-demo-${var.bucket_suffix}"

  tags = {
    Name        = "CloudBurst Demo Bucket"
    Environment = "dev"
    ManagedBy   = "terraform"
    DeployedBy  = "github-actions"
    TestTag = "pr-comment-test"
  }
}

# Enable versioning on the bucket
resource "aws_s3_bucket_versioning" "demo" {
  bucket = aws_s3_bucket.demo.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Output the bucket name
output "bucket_name" {
  description = "Name of the created S3 bucket"
  value       = aws_s3_bucket.demo.bucket
}

output "bucket_arn" {
  description = "ARN of the created S3 bucket"
  value       = aws_s3_bucket.demo.arn
}