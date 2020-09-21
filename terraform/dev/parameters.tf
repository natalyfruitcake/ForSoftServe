data "aws_ssm_parameter" "infra_env_name" {
  name = "/development/terraform/variables/infra_env_name"
}