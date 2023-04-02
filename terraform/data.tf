# Fetch the current AWS region used by the Terraform provider
data "aws_region" "current" {}

# Fetch the current AWS account information (ID, user ID, and ARN)
data "aws_caller_identity" "current" {}

# Fetch available Availability Zones in the current region
data "aws_availability_zones" "this" {}
