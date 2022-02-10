### zone a

resource "aws_nat_gateway" "nat-gw-a" {
  allocation_id = aws_eip.nat-epi_a.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name = "gw NAT A"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_eip" "nat-epi_a" {
 # instance = aws_nat_gateway.nat-gw.id - error cycle
  vpc      = true
}


### ============================== zone b ==============================

resource "aws_nat_gateway" "nat-gw-b" {
  allocation_id = aws_eip.nat-epi_b.id
  subnet_id     = aws_subnet.public_b.id

  tags = {
    Name = "gw NAT B"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_eip" "nat-epi_b" {
 # instance = aws_nat_gateway.nat-gw.id - error cycle
  vpc      = true
}