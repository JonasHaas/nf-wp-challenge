terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  # @replace bucket = "" with your own unique bucket name
  backend "s3" {
    bucket = "lab-environment-state-bucket"
    key    = "main.tfstate"
    region = var.region
  }
}

# Configure the AWS Provider
provider "aws"
  region  = var.region
  profile = var.cred_profile_name
}

data "aws_region" "current" {}