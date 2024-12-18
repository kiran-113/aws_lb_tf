resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "my-vpc-lb"
  }
}

# Create a public subnet with a route to the Internet Gateway
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true # Instances receive a public IP to denote a public subnet
  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_subnet" "public-2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.5.0/24"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true # Instances receive a public IP to denote a public subnet
  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "main"
  }
}

# Associating the public route table with an Internet Gateway
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

# Create a private subnet without a direct route to the Internet Gateway
resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = false # Instances do not receive a public IP to denote a private subnet
  tags = {
    Name = "Private Subnet"
  }
}

resource "aws_subnet" "private-2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = false # Instances do not receive a public IP to denote a private subnet
  tags = {
    Name = "Private Subnet"
  }
}
