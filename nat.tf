resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.nat.id       # Assume you have an EIP for the NAT
  subnet_id     = aws_subnet.public.id # This should be a public subnet

}

# Update your routings to use the NAT Gateway for internet access for private instances
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.example.id
  }
}

# Create a separate resource to associate the route table with the specified private subnet
resource "aws_route_table_association" "private_rta" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_rt.id
}
