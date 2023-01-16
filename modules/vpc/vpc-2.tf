#----------------------------------------------------
## VPC 2
resource "aws_vpc" "vpc_2" {
  cidr_block       = var.vpc_cidr[1]
  enable_dns_hostnames = true
  
  tags = {
    Name = "vpc 2"
  }
}

#----------------------------------------------------
## Subnet
resource "aws_subnet" "vpc_2_private_subnet" {
  vpc_id     = aws_vpc.vpc_2.id
  cidr_block = "10.1.0.0/24"
  availability_zone = var.availability_zone[0]

  tags = {
    "Name" = "vpc-2-private-subnet"
  }
}

resource "aws_subnet" "vpc_2_public_subnet" {
  vpc_id     = aws_vpc.vpc_2.id
  cidr_block = "10.1.1.0/24"
  availability_zone = var.availability_zone[1]

  tags = {
    "Name" = "vpc-2-public-subnet"
  }
}

#----------------------------------------------------
## Internet Gateway
resource "aws_internet_gateway" "vpc_2_igw" {
  vpc_id = aws_vpc.vpc_2.id

  tags = {
    "Name" = "vpc-2-igw"
  }
}

#----------------------------------------------------
## Route Table
resource "aws_route_table" "vpc-2-public-rt" {
  vpc_id = aws_vpc.vpc_2.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_2_igw.id
  }

  tags = {
    "Name" = "vpc-2-public-rt"
  }
}

resource "aws_route_table_association" "vpc_2_public_asso" {
  subnet_id      = aws_subnet.vpc_2_public_subnet.id
  route_table_id = aws_route_table.vpc-2-public-rt.id
}