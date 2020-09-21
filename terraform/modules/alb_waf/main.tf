resource "aws_wafv2_web_acl" "alb_waf_acl" {
  provider    = aws
  name        = "alb-waf-acl-${var.infra_env_name}"
  description = "AWS managed rules"
  scope       = "REGIONAL"

  default_action {
    block {}
  }
  rule {
    name     = "FindHeaderToken"
    priority = 0

    action {
      allow {}
    }

    statement {
      byte_match_statement {
        search_string = "kj4cX29HFNbw2M9W"
        field_to_match {
            single_header {
                name = "x-token-verification"
            }
        }
        positional_constraint = "EXACTLY"
        text_transformation {
            type = "NONE"
            priority = 0
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "FindHeaderToken"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "alb-waf-acl-${var.infra_env_name}"
      sampled_requests_enabled   = true
    }
}

resource "aws_wafv2_web_acl_association" "alb-waf-acl-association" {
  resource_arn = var.resource_arn
  web_acl_arn  = var.web_acl_arn
}