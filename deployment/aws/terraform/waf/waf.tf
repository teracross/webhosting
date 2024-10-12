terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.70.0"
    }
  }

  required_version = ">= 1.5.7"
}

provider "aws" {
  alias  = "cloudfront_waf"
  region = "us-east-1"
}

resource "aws_wafv2_web_acl" "cloudfront_waf" {
  name     = "cloudfront_waf"
  scope    = "CLOUDFRONT"
  provider = aws.cloudfront_waf

  default_action {
    block {}
  }

  rule {
    name     = "AWS-AWSManagedRulesAmazonIpReputationList"
    priority = 0

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesAmazonIpReputationList"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
    priority = 2

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesBotControlRuleSet"
    priority = 3

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesBotControlRuleSet"
        vendor_name = "AWS"

        managed_rule_group_configs {
          aws_managed_rules_bot_control_rule_set {
            inspection_level = "COMMON"
          }
        }

        rule_action_override {
          action_to_use {
            count {}
          }
          name = "CategoryAdvertising"
        }

        rule_action_override {
          action_to_use {
            count {}
          }
          name = "CategoryArchiver"
        }

        rule_action_override {
          action_to_use {
            count {}
          }
          name = "CategoryContentFetcher"
        }

        rule_action_override {
          action_to_use {
            count {}
          }
          name = "CategoryEmailClient"
        }

        rule_action_override {
          action_to_use {
            count {}
          }
          name = "CategoryHttpLibrary"
        }

        rule_action_override {
          action_to_use {
            count {}
          }
          name = "CategoryLinkChecker"
        }

        rule_action_override {
          action_to_use {
            count {}
          }
          name = "CategoryMiscellaneous"
        }

        rule_action_override {
          action_to_use {
            count {}
          }
          name = "CategoryMonitoring"
        }

        rule_action_override {
          action_to_use {
            count {}
          }
          name = "CategoryScrapingFramework"
        }

        rule_action_override {
          action_to_use {
            count {}
          }
          name = "CategorySearchEngine"
        }

        rule_action_override {
          action_to_use {
            count {}
          }
          name = "CategorySecurity"
        }

        rule_action_override {
          action_to_use {
            count {}
          }
          name = "CategorySeo"
        }

        rule_action_override {
          action_to_use {
            count {}
          }
          name = "CategorySocialMedia"
        }

        rule_action_override {
          action_to_use {
            count {}
          }
          name = "CategoryAI"
        }

        rule_action_override {
          action_to_use {
            count {}
          }
          name = "SignalAutomatedBrowser"
        }

        rule_action_override {
          action_to_use {
            count {}
          }
          name = "SignalKnownBotDataCenter"
        }

        rule_action_override {
          action_to_use {
            count {}
          }
          name = "SignalNonBrowserUserAgent"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesBotControlRuleSet"
      sampled_requests_enabled   = true
    }

  }

  tags = {
    Usecase = "webhosting"
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "AWS-webhosting-waf"
    sampled_requests_enabled   = true
  }
}

output "wafv2_arn" {
  value       = aws_wafv2_web_acl.cloudfront_waf.arn
  description = "ARN for CloudFront WAF ACL"
}