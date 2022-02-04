/*
  Database Servers
*/
resource "aws_security_group" "db" {
    name = "vpc_db"
    description = "Allow incoming database connections."

    ingress { # SQL Server
        from_port = 1433
        to_port = 1433
        protocol = "tcp"
        security_groups = ["${aws_security_group.web.id}"]
    }
    ingress { # MySQL
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = ["${aws_security_group.web.id}"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${aws_vpc.main.cidr_block}"]
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["${aws_vpc.main.cidr_block}"]
    }

    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
 # allow ping to go out
    egress {
            from_port = -1
            to_port = -1
            protocol = "icmp"
            cidr_blocks = ["${aws_vpc.main.cidr_block}"]
        }

    vpc_id = "${aws_vpc.main.id}"


}

resource "aws_instance" "db-1" {
   # ami = "${lookup(var.amis, var.aws_region)}"
    ami = "ami-055d15d9cfddf7bd3"
    instance_type = "t2.micro"
    key_name = "aws_key"
    vpc_security_group_ids = ["${aws_security_group.db.id}"]
    subnet_id = "${aws_subnet.private.id}"
    source_dest_check = false



    tags = {
        Name = "DB Server 1"
    }
}