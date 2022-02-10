# Availability Zones are automatically selected if not specified
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
# see https://nickcharlton.net/posts/terraform-aws-vpc.html

########  availability zone A
# public subnet has a route to internet gateway
resource "aws_subnet" "public_a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "${var.public_subnet_cidr_a}"

  map_public_ip_on_launch = true
  availability_zone = "${var.aws_region}a"
  depends_on = [aws_internet_gateway.gw]
  tags = {
    Name = "public a"
  }
}

resource "aws_route_table" "public-route-table_a" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }
}

resource "aws_route_table_association" "public-route-table-assoc_a" {
    subnet_id = aws_subnet.public_a.id
    route_table_id = aws_route_table.public-route-table_a.id
}


######## ========================= availability zone B ==========================

resource "aws_subnet" "public_b" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "${var.public_subnet_cidr_b}"

  map_public_ip_on_launch = true
  availability_zone = "${var.aws_region}b"
  depends_on = [aws_internet_gateway.gw]
  tags = {
    Name = "public b"
  }
}


resource "aws_route_table" "public-route-table_b" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }
}

resource "aws_route_table_association" "public-route-table-assoc_b" {
    subnet_id = aws_subnet.public_b.id
    route_table_id = aws_route_table.public-route-table_b.id
}