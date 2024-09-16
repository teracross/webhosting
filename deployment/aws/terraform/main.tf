terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "webhosting" {
  bucket = "eddevhosting"

  tags = {
    Name        = "webhosting"
    Environment = "Dev"
  }
}

resource "aws_s3_object" "index_page" {
  bucket       = aws_s3_bucket.webhosting.id
  key          = "index.html"
  source       = "../../../index.html"
  etag         = md5("../../../index.html")
  content_type = "text/html"
}

resource "aws_s3_object" "css_sheet" {
  bucket       = aws_s3_bucket.webhosting.id
  key          = "/css/styles.css"
  source       = "../../../css/styles.css"
  etag         = md5("../../../css/syltes.css")
  content_type = "text/css"
}

# note - for security purposes block public policy should be enabled when not modifying bucket policy
resource "aws_s3_bucket_public_access_block" "bucket_public_access" {
  bucket = aws_s3_bucket.webhosting.id

  block_public_acls = true
  block_public_policy = true 
  ignore_public_acls = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "webhosting_config" {
  bucket = aws_s3_bucket.webhosting.id

  index_document {
    suffix = "index.html"
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
  policy = data.aws_iam_policy_document.allow_public_access_policy.json
}

data "aws_iam_policy_document" "allow_public_access_policy" {
  statement {
    sid = "PublicReadObject"
    actions = ["s3:GetObject"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.webhosting.bucket}/*"
    ]
  }
}
