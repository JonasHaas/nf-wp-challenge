# Fetch the current AWS region used by the Terraform provider
data "aws_region" "current" {}

# Fetch the current AWS account information (ID, user ID, and ARN)
data "aws_caller_identity" "current" {}

# Fetch available Availability Zones in the current region
data "aws_availability_zones" "this" {}

# Retrieves the ID of the latest Amazon Linux AMI that matches specific filters.
data "aws_ami" "amazon_linux" {
  #executable_users = ["self"]
  most_recent = true
  name_regex  = "^amzn2*"
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Retrieves information about running instances that match specific filters.
data "aws_instances" "wp-web" {
  instance_tags = var.tags

  filter {
    name   = "key-name"
    values = ["${var.prefix}-${var.environment}-key"]
  }
  instance_state_names = ["running"]
  depends_on           = [module.wp-asg, resource.time_sleep.wait_180_seconds]
}
