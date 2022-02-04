


#data "aws_ami" "ubuntu" {
#  most_recent = true

#  filter {
#    name   = "name"
#    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#  }

#  filter {
#    name   = "virtualization-type"
#    values = ["hvm"]
#  }

#  owners = ["099720109477"] # Canonical
#}


resource "aws_instance" "web" {
  # ami           = data.aws_ami.ubuntu.id
  ami = "ami-055d15d9cfddf7bd3"
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.public_if.id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }

  key_name= "aws_key"
#  vpc_security_group_ids = [aws_security_group.main.id]
# https://stackoverflow.com/questions/57279090/error-network-interface-conflicts-with-vpc-security-group-ids

   provisioner "remote-exec" {
      inline = [
        "touch hello.txt",
        "echo helloworld remote provisioner >> hello.txt",
      ]

      connection {
              type        = "ssh"
              host        = self.public_ip
              user        = "ubuntu"
              private_key = file(".ssh/aws.pem")
              timeout     = "4m"
           }
    }

    provisioner "file" {
      source      = ".ssh/aws.pem"
      destination = "aws.pem"

      connection {
                    type        = "ssh"
                    host        = self.public_ip
                    user        = "ubuntu"
                    private_key = file(".ssh/aws.pem")
                    timeout     = "4m"
                 }
    }

  tags = {
    Name = "HelloWorld"
  }
}

# open all egresss
resource "aws_security_group" "web" {

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


# if manually setting ip address
resource "aws_network_interface" "public_if" {
  subnet_id   = aws_subnet.public.id
  private_ips = ["10.0.0.10"]
  security_groups = [aws_security_group.web.id]
  tags = {
    Name = "primary_network_interface"
  }
}




# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
#resource "aws_eip" "lb" {
#  instance = aws_instance.web.id
#  vpc      = true
#  associate_with_private_ip = "10.0.1.10"
#  depends_on                = [aws_internet_gateway.gw]
#}
