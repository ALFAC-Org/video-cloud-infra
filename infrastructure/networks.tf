# VPC
resource "aws_vpc" "video_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = var.vpc_name
  }
}

# Public Subnets
resource "aws_subnet" "video_public_subnet_1" {
  vpc_id            = aws_vpc.video_vpc.id
  cidr_block        = var.subnet_public_1_cidr_block
  availability_zone = var.subnet_availability_zone_az_1

  tags = {
    Name = "video_public_subnet_1"
  }
}

resource "aws_subnet" "video_public_subnet_2" {
  vpc_id            = aws_vpc.video_vpc.id
  cidr_block        = var.subnet_public_2_cidr_block
  availability_zone = var.subnet_availability_zone_az_2

  tags = {
    Name = "video_public_subnet_2"
  }
}

# Private Subnets
resource "aws_subnet" "video_private_subnet_1" {
  vpc_id            = aws_vpc.video_vpc.id
  cidr_block        = var.subnet_private_1_cidr_block
  availability_zone = var.subnet_availability_zone_az_1

  tags = {
    Name = "video_private_subnet_1"
  }
}

resource "aws_subnet" "video_private_subnet_2" {
  vpc_id            = aws_vpc.video_vpc.id
  cidr_block        = var.subnet_private_2_cidr_block
  availability_zone = var.subnet_availability_zone_az_2

  tags = {
    Name = "video_private_subnet_2"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "video_igw" {
  vpc_id = aws_vpc.video_vpc.id

  tags = {
    Name = "video_igw"
  }
}

# Public route table
resource "aws_route_table" "video_public_rt" {
  vpc_id = aws_vpc.video_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.video_igw.id
  }

  tags = {
    Name = "video_public_rt"
  }
}

# Public route table association - 1
resource "aws_route_table_association" "video_public_rt_association_1" {
  subnet_id      = aws_subnet.video_public_subnet_1.id
  route_table_id = aws_route_table.video_public_rt.id
}

# Public route table association - 2
resource "aws_route_table_association" "video_public_rt_association_2" {
  subnet_id      = aws_subnet.video_public_subnet_2.id
  route_table_id = aws_route_table.video_public_rt.id
}

# Private route table
resource "aws_route_table" "video_private_rt" {
  vpc_id = aws_vpc.video_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.video_nat_gw.id
  }

  tags = {
    Name = "video_private_rt"
  }
}

# Private route table association - 1
resource "aws_route_table_association" "video_private_rt_association_1" {
  subnet_id      = aws_subnet.video_private_subnet_1.id
  route_table_id = aws_route_table.video_private_rt.id
}

# Private route table association - 2
resource "aws_route_table_association" "video_private_rt_association_2" {
  subnet_id      = aws_subnet.video_private_subnet_2.id
  route_table_id = aws_route_table.video_private_rt.id
}

# Elastic IP for NAT Gateway
resource "aws_eip" "video_nat_eip" {
  domain = "vpc"
}

# NAT Gateway
resource "aws_nat_gateway" "video_nat_gw" {
  allocation_id = aws_eip.video_nat_eip.id
  subnet_id     = aws_subnet.video_public_subnet_1.id

  tags = {
    Name = "video_nat_gw"
  }
}
