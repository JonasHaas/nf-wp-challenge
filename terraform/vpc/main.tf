resource "aws_vpc" "${var.stack_name}_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name    = "${var.stack_name}-vpc"
  }
}