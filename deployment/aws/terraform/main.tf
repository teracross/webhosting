terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

variable "aws_root_user" {
  type = string
}

variable "aws_iam_user" {
  type = string
}


provider "aws" {
  region = "us-west-2"
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
    sid = "CloudFrontReadAccess"
    actions = ["s3:GetObject"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    resources = [
      "arn:aws:s3:::eddevhosting/*",
      "arn:aws:s3:::eddevhosting"
    ]
    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "AWS:SourceARN"
      values = ["${aws_cloudfront_distribution.webhosting_distribution.arn}"]
    }
  }

  statement {
    sid = "AdminAccess"
    actions = ["*"]

    principals {
      type        = "Service"
      identifiers = ["${env.aws_root_user}", "${env.aws_iam_user}"]
    }
    resources = [
      "${aws_s3_bucket.webhosting.arn}/*",
      "${aws_s3_bucket.webhosting.arn}"
    ]
  }

  statement {
    sid = "CICD_Access"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketPolicy",
      "s3:GetBucketPolicyStatus",
      "s3:GetBucketVersioning",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject",
      "s3:PutBucketPolicy",
      "s3:PutBucketVersioning"]

    principals {
      type        = "Service"
      identifiers = ["${env.aws_root_user}", "${env.aws_iam_user}"]
    }
    resources = [
      "${aws_s3_bucket.webhosting.arn}/*",
      "${aws_s3_bucket.webhosting.arn}"
    ]
  }
}

resource "aws_cloudfront_distribution" "webhosting_distribution" {
  origin {
    domain_name = aws_s3_bucket.webhosting.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.bucket_oac.name
    origin_id=aws_s3_bucket.webhosting.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  
  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations = ["US"]
    }
  }
  
  viewer_certificate {
    cloudfront_default_certificate= true
  }

  default_cache_behavior {
    cache_policy_id= "658327ea-f89d-4fab-a63d-7e88639e58f6"
    allowed_methods= ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id= aws_s3_bucket.webhosting.id
    viewer_protocol_policy = "redirect-to-https"
  }
}

resource "aws_cloudfront_origin_access_control" "bucket_oac" {
  name                              = "${aws_s3_bucket.webhosting.bucket}-oac"
  description                       = "Origin Access Control for ${aws_s3_bucket.webhosting.bucket} S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

#TODO: need to add WAF for CloudFront and enable origin shield