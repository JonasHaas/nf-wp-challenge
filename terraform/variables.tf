variable "region" {
    default = "eu-central-1"
}

variable "stack_name" {
    description = "name for the project stack - used as prefix for names"
    default     = "jsh"
}

variable "cred_profile_name" {
    description = "Use the profile name for your AWS CLI credentials"
    default     = "default"
}

variable "internet_cidr_block" {
    default = ["0.0.0.0/0"]
}
