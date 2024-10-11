terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.70.0"
    }
  }

  required_version = ">= 1.5.7"
}

variable "AWS_ROOT_USER" {
  type = string
}

variable "AWS_IAM_USER" {
  type = string
}

variable "AWS_DEPLOYMENT_ROLE" {
  type = string
}

resource "aws_s3_bucket" "webhosting" {
  bucket = "eddevhosting"

  tags = {
    Name        = "webhosting"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.webhosting.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.webhosting.id
  policy = data.aws_iam_policy_document.bucket_access_policy.json
}

data "aws_iam_policy_document" "bucket_access_policy" {
  
  statement {
    sid     = "AdminAccess"
    actions = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["${var.AWS_ROOT_USER}", "${var.AWS_IAM_USER}"]
    }
    resources = [
      "${aws_s3_bucket.webhosting.arn}/*",
      "${aws_s3_bucket.webhosting.arn}"
    ]
  }

  statement {
    sid = "CICD_Bucket_Access"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketPolicy",
      "s3:GetBucketPolicyStatus",
      "s3:GetBucketVersioning",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject",
      "s3:PutBucketPolicy",
      "s3:PutBucketVersioning"
    ]

    principals {
      type        = "AWS"
      identifiers = ["${var.AWS_DEPLOYMENT_ROLE}"]
    }
    resources = [
      "${aws_s3_bucket.webhosting.arn}/*",
      "${aws_s3_bucket.webhosting.arn}"
    ]
  }
}

output "s3_bucket_arn" {
  value       = aws_s3_bucket.webhosting.arn
  description = "ARN value for s3 bucket used to store assets for webhosting"
}

output "s3_bucket_policy" {
  value       = aws_s3_bucket_policy.bucket_policy.policy
  description = "S3 bucket access policy"
#   sensitive   = true
}

output "s3_bucket_origin_id" {
  value       = aws_s3_bucket.webhosting.bucket
  description = "Unique Origin ID of s3 bucket"
}

output "s3_bucket_regional_domain_name" {
  value       = aws_s3_bucket.webhosting.bucket_regional_domain_name
  description = "Regional domain name of the S3 bucket"
}

output "s3_bucket_id" {
  value       = aws_s3_bucket.webhosting.id
  description = "ID of the S3 bucket"
}
