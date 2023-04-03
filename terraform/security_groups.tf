# Create an SSH security group using the terraform-aws-modules/security-group/aws module, 
# allowing SSH access from anywhere and access from within the VPC

module "ssh_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.17.1"

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


# Create an HTTP security group using the terraform-aws-modules/security-group/aws module, 
# allowing HTTP access from anywhere and egress to the VPC
module "http_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.17.1"

  name        = "${var.prefix}-${var.environment}-http-sg"
  description = "Frontend Security Group"
  vpc_id      = module.vpc.vpc_id

  # ingress
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

module "db_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.17.1"

  name        = "${var.prefix}-${var.environment}-db-sg"
  description = "MySQL Security Group"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "MySQL access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]
  tags = var.tags
}

module "efs_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"

  name        = "${var.prefix}-${var.environment}-efs-sg"
  description = "EFS Security Group"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_cidr_blocks = [module.vpc.vpc_cidr_block]
  ingress_rules       = ["all-all"]

  tags = var.tags
}
