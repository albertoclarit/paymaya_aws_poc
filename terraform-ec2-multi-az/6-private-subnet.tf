
### private Subnet A
resource "aws_subnet" "private_a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "${var.private_subnet_cidr_a}"
  availability_zone = "${var.aws_region}a"
  tags = {
    Name = "private a"
  }
}


resource "aws_route_table" "private-route-table_a" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nat-gw-a.id
    }
}

resource "aws_route_table_association" "private-route-table-assoc_a" {
    subnet_id = aws_subnet.private_a.id
    route_table_id = aws_route_table.private-route-table_a.id
}

### ========================== private Subnet B ======================

resource "aws_subnet" "private_b" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "${var.private_subnet_cidr_b}"
  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "private b"
  }
}



resource "aws_route_table" "private-route-table_b" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nat-gw-b.id
    }
}

resource "aws_route_table_association" "private-route-table-assoc_b" {
    subnet_id = aws_subnet.private_b.id
    route_table_id = aws_route_table.private-route-table_b.id
}
