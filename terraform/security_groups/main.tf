# Security Groups
resource "aws_security_group" "allow_ssh" {
  name_prefix = "${var.stack_name}-"
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.internet_cidr_block
  }

  tags = {
    Name = "${var.stack_name}-allow-ssh"
  }
}

resource "aws_security_group" "allow_all_outbound" {
  name_prefix = "${var.stack_name}-"
  name        = "allow_all_outbound"
  description = "Allow all outbound traffic"
  vpc_id = aws_vpc.my_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.internet_cidr_block
  }

  tags = {
    Name = "${var.stack_name}-allow-all-outbound"
  }
}

# NAT Security Group
resource "aws_security_group" "nat_sg" {
  name_prefix = "${var.stack_name}-"

  vpc_id = aws_vpc.my_vpc.id

  # Allow outbound traffic to the internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound traffic from instances in the private subnet
  ingress {
    from_port   = 0 
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_subnet.private_subnet_1.cidr_block]
  }

  tags = {
    Name = "${var.stack_name}-nat-sg"
  }
}