# Availability Zones are automatically selected if not specified
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
# see https://nickcharlton.net/posts/terraform-aws-vpc.html

# public subnet has a route to internet gateway
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"

  map_public_ip_on_launch = true
  depends_on = [aws_internet_gateway.gw]
  tags = {
    Name = "public"
  }
}

resource "aws_route_table" "public-route-table" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }

#    tags {
#        Name = "Public Subnet"
#    }
}

resource "aws_route_table_association" "public-route-table-assoc" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.public-route-table.id
}
