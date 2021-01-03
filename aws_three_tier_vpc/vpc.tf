## Create the main VPC and its components

# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name      = "MYVPC"
    Generator = "Terraform"
  }
}

# Subnets
locals {
  subnet_count = length(data.aws_availability_zones.available_az.names) > 2 ? 3 : 2
}

resource "aws_subnet" "WebSubnets" {
  count                   = local.subnet_count
  vpc_id                  = aws_vpc.main.id
  availability_zone       = data.aws_availability_zones.available_az.names[count.index]
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 4, count.index + 0 + 1)
  map_public_ip_on_launch = true
  tags = {
    Name      = "WebSubnet-${count.index + 1}"
    Generator = "Terraform"
  }
}

resource "aws_subnet" "DBSubnets" {
  count                   = local.subnet_count
  vpc_id                  = aws_vpc.main.id
  availability_zone       = data.aws_availability_zones.available_az.names[count.index]
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 4, count.index + 3 + 1)
  map_public_ip_on_launch = false
  tags = {
    Name      = "DBSubnet-${count.index + 1}"
    Generator = "Terraform"
  }
}

resource "aws_subnet" "BackendSubnets" {
  count                   = local.subnet_count
  vpc_id                  = aws_vpc.main.id
  availability_zone       = data.aws_availability_zones.available_az.names[count.index]
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 4, count.index + 6 + 1)
  map_public_ip_on_launch = false
  tags = {
    Name      = "BackendSubnet-${count.index + 1}"
    Generator = "Terraform"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name      = "MYIGW"
    Generator = "Terraform"
  }
}

# Public route table
resource "aws_route_table" "PublicSubnetRT" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name      = "PublicRT"
    Generator = "Terraform"
  }
}

# Public RT association
resource "aws_route_table_association" "PublicRTAssocWeb" {
  count          = local.subnet_count
  subnet_id      = aws_subnet.WebSubnets[count.index].id
  route_table_id = aws_route_table.PublicSubnetRT.id
}

# EIP for NAT Gateway
resource "aws_eip" "NATGWEIP" {
  vpc = true
  tags = {
    Name      = "MYNATGWEIP"
    Generator = "Terraform"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "NATGW" {
  allocation_id = aws_eip.NATGWEIP.id
  subnet_id     = aws_subnet.WebSubnets[0].id
}

# Private route table
resource "aws_route_table" "PrivateSubnetRT" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NATGW.id
  }

  tags = {
    Name      = "PrivateRT"
    Generator = "Terraform"
  }
}

# Private RT association
resource "aws_route_table_association" "PrivateRTAssocBackend" {
  count          = local.subnet_count
  subnet_id      = aws_subnet.BackendSubnets[count.index].id
  route_table_id = aws_route_table.PrivateSubnetRT.id
}

resource "aws_route_table_association" "PublicRTAssocDB" {
  count          = local.subnet_count
  subnet_id      = aws_subnet.DBSubnets[count.index].id
  route_table_id = aws_route_table.PrivateSubnetRT.id
}

# Security groups
resource "aws_security_group" "allow_all_within_vpc" {
  name        = "allow_all"
  description = "Allow traffic within VPC"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "allow_all_within_vpc"
    Generator = "Terraform"
  }
}

resource "aws_security_group" "ssh_only" {
  name        = "ssh_only"
  description = "Allow SSH from everywhere"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "ssh_only"
    Generator = "Terraform"
  }
}

resource "aws_security_group" "web_access" {
  name        = "web_access"
  description = "Allow external web traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "web_access"
    Generator = "Terraform"
  }
}