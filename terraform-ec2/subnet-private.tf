resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
 # availability_zone = "ap-southeast-1"
  tags = {
    Name = "private"
  }
}


resource "aws_route_table" "private-route-table" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
  #      instance_id =  aws_instance.nat.id - deprecated
        gateway_id = aws_nat_gateway.nat-gw.id


    }

 #   tags {
 #       Name = "Private Subnet"
 #   }
}

resource "aws_route_table_association" "private-route-table-assoc" {
    subnet_id = aws_subnet.private.id
    route_table_id = aws_route_table.private-route-table.id
}

