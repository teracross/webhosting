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


provider "aws" {
  region = "us-west-2"
}

provider "aws" {
  alias  = "cloudfront_waf"
  region = "us-east-1"
}

module "s3_bucket" {
  source = "./s3/"

  AWS_ROOT_USER       = var.AWS_ROOT_USER
  AWS_IAM_USER        = var.AWS_IAM_USER
  AWS_DEPLOYMENT_ROLE = var.AWS_DEPLOYMENT_ROLE
}

module "cloudfront_waf" {
  source = "./waf/"
}

resource "aws_s3_object" "index_page" {
  bucket       = module.s3_bucket.s3_bucket_id
  key          = "index.html"
  source       = "../../../index.html"
  etag         = md5("../../../index.html}")
  content_type = "text/html"
  depends_on   = [module.s3_bucket.bucket_policy]
}

resource "aws_s3_object" "css_sheet" {
  bucket       = module.s3_bucket.s3_bucket_id
  key          = "/css/styles.css"
  source       = "../../../css/styles.css"
  etag         = md5("../../../css/syltes.css")
  content_type = "text/css"
  depends_on   = [module.s3_bucket.bucket_policy]
}


data "aws_iam_policy_document" "webhosting_updates_role" {
  statement {
    effect = "Allow"

    actions = [
      "cloudfront:UpdateDistribution",
      "cloudfront:DeleteOriginAccessControl"
    ]

    principals {
      type        = "AWS"
      identifiers = ["$(var.AWS_DEPLOYMENT_ROLE)}"]
    }

    resources = [
      "${aws_cloudfront_distribution.webhosting_distribution.arn}"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "wafv2:PutManagedRuleSetVersions",
      "wafv2:DeleteLoggingConfiguration",
      "wafv2:PutLoggingConfiguration",
      "wafv2:PutFirewallManagerRuleGroups",
      "wafv2:UpdateWebACL",
      "wafv2:UpdateRuleGroup",
      "wafv2:DeletePermissionPolicy",
      "wafv2:PutPermissionPolicy",
      "wafv2:DeleteWebACL"
    ]

    principals {
      type        = "AWS"
      identifiers = ["$(var.AWS_DEPLOYMENT_ROLE)}"]
    }

    resources = [
      "${module.cloudfront_waf.wafv2_arn}"
    ]
  }
}

resource "aws_cloudfront_distribution" "webhosting_distribution" {
  origin {
    domain_name              = module.s3_bucket.s3_bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.bucket_oac.name
    origin_id                = module.s3_bucket.s3_bucket_origin_id
  }
  web_acl_id = module.cloudfront_waf.wafv2_arn

  enabled          = true
  is_ipv6_enabled  = true
  retain_on_delete = true
  http_version     = "http3"

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = ["none"]
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  default_cache_behavior {
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = module.s3_bucket.s3_bucket_id
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    compress               = true
  }

  depends_on = [
    aws_cloudfront_origin_access_control.bucket_oac,
    module.cloudfront_waf.wafv2_arn,
    module.s3_bucket.s3_bucket_arn,
    aws_s3_object.css_sheet,
    aws_s3_object.index_page
  ]
}

resource "aws_cloudfront_origin_access_control" "bucket_oac" {
  name                              = "${module.s3_bucket.s3_bucket_arn}-oac"
  description                       = "Origin Access Control for ${module.s3_bucket.s3_bucket_arn} S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Granting CloudFront access to S3 bucket objects
resource "aws_s3_bucket_policy" "bucket_policy_update" {
  bucket     = module.s3_bucket.s3_bucket_arn
  policy     = data.aws_iam_policy_document.s3_bucket_policy_update.json
  depends_on = [aws_cloudfront_distribution.webhosting_distribution]
}

data "aws_iam_policy_document" "s3_bucket_policy_update" {
  source_policy_documents = [module.s3_bucket.s3_bucket_policy]

  statement {
    sid     = "CloudFrontReadAccess"
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
      values   = ["${aws_cloudfront_distribution.webhosting_distribution.arn}"]
    }
  }

  depends_on = [aws_cloudfront_distribution.webhosting_distribution]
}
