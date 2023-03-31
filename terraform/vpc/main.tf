resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name    = "${var.stack_name}-vpc"
  }
}