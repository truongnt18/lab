

# Create a VPC
resource "aws_vpc" "web" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "web VPC"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}



resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.web.id
  cidr_block = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    "Name" = "public-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.web.id
  cidr_block = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    "Name" = "private-subnet"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "web" {
  vpc_id = aws_vpc.web.id

  tags = {
    Name = "web IGW"
  }
}


resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.web.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.web.id
  }

  tags = {
    "Name" = "rt-public-subnet"
  }

}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}



# Create a route table for the private subnet
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.web.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.wordpress.id
  }


  tags = {
    Name = "Private Route Table"
  }
}

# Associate the private subnet with the private route table
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private.id
}


# Create a NAT Gateway
resource "aws_nat_gateway" "wordpress" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "web NAT Gateway"
  }
}

# Create an Elastic IP for the NAT Gateway
resource "aws_eip" "nat" {
  vpc   = true
}




