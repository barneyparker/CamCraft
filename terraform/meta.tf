terraform {
  required_version = "~> 1.2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.21.0"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region = "eu-west-1"

  default_tags {
    tags = var.default_tags
  }
}

provider "aws" {
  alias  = "dns"
  region = "eu-west-1"

  assume_role {
    role_arn = "arn:aws:iam::610879547730:role/core_dns"
  }

  default_tags {
    tags = var.default_tags
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
