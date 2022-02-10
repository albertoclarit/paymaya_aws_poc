
resource "aws_instance" "web-a" {
  ami = "ami-055d15d9cfddf7bd3" # ubuntu
  instance_type = "t2.micro"

  availability_zone = "${var.aws_region}a"
  network_interface {
    network_interface_id = aws_network_interface.nginx-a.id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }

  key_name= "aws_key"

   provisioner "remote-exec" {
      inline = [
        "sudo apt -y install nginx",
      ]

      connection {
              type        = "ssh"
              host        = self.public_ip
              user        = "ubuntu"
              private_key = file(".ssh/aws.pem")
              timeout     = "4m"
           }
    }

  tags = {
    Name = "Nginx A"
  }
}


resource "aws_instance" "web-b" {
  ami = "ami-055d15d9cfddf7bd3" # ubuntu
  instance_type = "t2.micro"

  availability_zone = "${var.aws_region}b"
  network_interface {
    network_interface_id = aws_network_interface.nginx-b.id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }

  key_name= "aws_key"

   provisioner "remote-exec" {
      inline = [
        "sudo apt -y install nginx",
      ]

      connection {
              type        = "ssh"
              host        = self.public_ip
              user        = "ubuntu"
              private_key = file(".ssh/aws.pem")
              timeout     = "4m"
           }
    }

  tags = {
    Name = "Nginx B"
  }
}



# if manually setting ip address
resource "aws_network_interface" "nginx-a" {
  subnet_id   = aws_subnet.public_a.id
  security_groups = [aws_security_group.nginx-sg.id]
  tags = {
    Name = "nginx a network interface"
  }
}


resource "aws_network_interface" "nginx-b" {
  subnet_id   = aws_subnet.public_b.id
  security_groups = [aws_security_group.nginx-sg.id]
  tags = {
    Name = "nginx b network interface"
  }
}

# open all egresss
resource "aws_security_group" "nginx-sg" {

  tags = {
        Name = "nginx-sg"
      }

  vpc_id      = aws_vpc.main.id
  egress = [
    {
      cidr_blocks      = [ "0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
 ingress                = [
  {
      cidr_blocks      = [ "0.0.0.0/0", ]
      description      = ""
      from_port        = 80
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 80
   },
    {
        cidr_blocks      = [ "0.0.0.0/0", ]
        description      = ""
        from_port        = 443
        ipv6_cidr_blocks = []
        prefix_list_ids  = []
        protocol         = "tcp"
        security_groups  = []
        self             = false
        to_port          = 443
     },
   {
     cidr_blocks      = [ "0.0.0.0/0", ]
     description      = ""
     from_port        = 22
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     protocol         = "tcp"
     security_groups  = []
     self             = false
     to_port          = 22
  },
   {
       cidr_blocks      = [ "0.0.0.0/0", ]
       description      = ""
       from_port        = -1
       ipv6_cidr_blocks = []
       prefix_list_ids  = []
       protocol         = "icmp"
       security_groups  = []
       self             = false
       to_port          = -1
    }
  ]
}


