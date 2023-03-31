module "ssh_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"

  name        = "${var.prefix}-${var.environment}-ssh-sg"
  description = "SSH Security Group"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      description = "SSH access from anywhere"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      description = "Acess from within VPC"
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]

  # egress
  egress_cidr_blocks = var.internet_cidr_block
  egress_rules       = ["all-all"]

  tags = var.tags
}

module "http_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"

  name        = "${var.prefix}-${var.environment}-http-sg"
  description = "Frontend Security Group"
  vpc_id      = module.vpc.vpc_id

   ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "${var.environment}-http to ELB"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  ##### egress
  egress_with_cidr_blocks = [
    {
      description = "Access from within VPC"
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]

  tags = var.tags
}