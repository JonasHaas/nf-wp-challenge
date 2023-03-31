terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  # @replace bucket = "" with your own unique bucket name
  # @replace region with your desired region, do it also in the root variable.tf
  backend "s3" {
    bucket = "nvpnotbifz-state-bucket"
    key    = "main.tfstate"
    region = "eu-central-1"
  }
}

# Configure the AWS Provider
provider "aws" {
  region  = var.region
  profile = var.cred_profile_name
}