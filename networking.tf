# Internet Gateway
resource "aws_internet_gateway" "mlops_igw" {
  vpc_id = aws_vpc.mlops_vpc.id
  tags = { Name = "mlops-igw" }
}

# Route table for public subnets
resource "aws_route_table" "mlops_public_rt" {
  vpc_id = aws_vpc.mlops_vpc.id
  tags   = { Name = "mlops-public-rt" }
}

# Default route to internet
resource "aws_route" "mlops_igw_default" {
  route_table_id         = aws_route_table.mlops_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.mlops_igw.id
}

# Associate both subnets to the public route table
resource "aws_route_table_association" "mlops_assoc1" {
  subnet_id      = aws_subnet.mlops_subnet1.id
  route_table_id = aws_route_table.mlops_public_rt.id
}

resource "aws_route_table_association" "mlops_assoc2" {
  subnet_id      = aws_subnet.mlops_subnet2.id
  route_table_id = aws_route_table.mlops_public_rt.id
}

