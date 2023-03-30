# Public
resource "aws_subnet" "public_subnet_1" {
  name_prefix = "${var.stack_name}-"
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.pub_sub_1_cidr_block
  availability_zone       = "${data.aws_region.current.name}a"
  
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.stack_name}-public-subnet-1"
  }
}

# Private
resource "aws_subnet" "private_subnet_1" {
  name_prefix = "${var.stack_name}-"  
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.pri_sub_1_cidr_block
  availability_zone = "${data.aws_region.current.name}a"

  tags = {
    Name = "${var.stack_name}-private-subnet-1"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  name_prefix = "${var.stack_name}-"
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name    = "${var.stack_name}-internet-gateway"
  }
}

# Routing Table for Internet Gateway
resource "aws_route_table" "public" {
  name_prefix = "${var.stack_name}-"
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = var.internet_cidr_string
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.stack_name}-public-route-table"
  }
}

resource "aws_route_table_association" "public_subnet_1" {
  name_prefix = "${var.stack_name}-"
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public.id
}

# NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  name_prefix = "${var.stack_name}-"  
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id
  security_group_ids = [aws_security_group.nat_sg.id]
}

# Routing Table for Nat Gateway
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "${var.stack_name}-private-route-table"
  }
}

resource "aws_route_table_association" "private_subnet_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private.id
}


# Elastic IP
resource "aws_eip" "nat_eip" {
  vpc = true

  tags = {
    Name = "${var.stack_name}-elastic-ip"
  }
}