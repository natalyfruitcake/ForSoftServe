#---///---#

module "alb_waf" {
  source         = "../modules/alb_waf"
  infra_env_name = data.aws_ssm_parameter.infra_env_name.value
  web_acl_arn = module.alb_waf.alb_waf_acl_arn
  resource_arn = module.load_balancer.aws_lb_arn
}

#---///---#