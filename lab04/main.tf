provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_vpc" "vpc_demo" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "igw_demo" {
  vpc_id = aws_vpc.vpc_demo.id
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.vpc_demo.id
  cidr_block = "10.0.1.0/24"
  tags = {
    "Name" = "public-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.vpc_demo.id
  cidr_block = "10.0.2.0/24"
  tags = {
    "Name" = "private-subnet"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc_demo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_demo.id
  }

  tags = {
    "Name" = "rt-public-subnet"
  }

}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc_demo.id
  tags = {
    "Name" = "rt-private-subnet"
  }
}

resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

