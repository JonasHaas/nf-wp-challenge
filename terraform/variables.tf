variable "region" {
    default = "eu-central-1"
}

variable "prefix" {
  description = "Prefix for all the resources to be created. Please note thst 2 allows only lowercase alphanumeric characters and hyphen"
  default     = "wordpress"
}

variable "stack_name" {
    description = "name for the project stack - used as prefix for names"
    default     = "jsh"
}

variable "cred_profile_name" {
    description = "Use the profile name for your AWS CLI credentials"
    default     = "default"
}

variable "environment" {
  description = "Name of the application environment. e.g. dev, prod, test, staging"
  default     = "dev"
}

variable "internet_cidr_block" {
    default = ["0.0.0.0/0"]
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}
variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  default     = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  default     = ["10.0.100.0/24", "10.0.101.0/24", "10.0.102.0/24"]
}

variable "database_subnets_cidrs" {
  description = "List of CIDR blocks for db subnets"
  default     = ["10.0.200.0/24", "10.0.201.0/24", "10.0.202.0/24"]
}

variable "tags" {
  description = "AWS Tags to add to all resources created (where possible); see https://aws.amazon.com/answers/account-management/aws-tagging-strategies/"
  type        = map(any)
  default = {
    stack         = "wordpress"
  }
}