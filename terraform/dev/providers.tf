##################
# Remote backend
##################
terraform {
  backend "s3" {
    bucket         = "projectname-terraform-state"
    key            = "develop/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"

  }
}

##################
# Providers
##################
provider "aws" {
  version = "~> 2.62"
  region  = "us-east-1"
}

terraform {
  required_version = ">= 0.12.18"
  required_providers {
    aws = "~> 2.62"
  }
}
