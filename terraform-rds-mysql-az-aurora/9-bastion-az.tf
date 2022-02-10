
resource "aws_instance" "bastion-a" {
  ami = "ami-055d15d9cfddf7bd3" # ubuntu
  instance_type = "t2.micro"

  availability_zone = "${var.aws_region}a"
  network_interface {
    network_interface_id = aws_network_interface.bastion-a.id
    device_index         = 0
  }



    provisioner "remote-exec" {
              inline = [
                 "sudo apt -y update",
              #   "sudo apt -y upgrade",
                 "sudo apt -y install mysql-client",
              ]

              connection {
                      type        = "ssh"
                      host        = self.public_ip
                      user        = "ubuntu"
                      private_key = file(".ssh/aws.pem")
                      timeout     = "4m"
                   }
       }



  credit_specification {
    cpu_credits = "unlimited"
  }

  key_name= "aws_key"

  tags = {
    Name = "Bastion A"
  }
}


resource "aws_instance" "bastion-b" {
  ami = "ami-055d15d9cfddf7bd3" # ubuntu
  instance_type = "t2.micro"

  availability_zone = "${var.aws_region}b"
  network_interface {
    network_interface_id = aws_network_interface.bastion-b.id
    device_index         = 0
  }
  credit_specification {
    cpu_credits = "unlimited"
  }

  key_name= "aws_key"


  provisioner "remote-exec" {
          inline = [
             "sudo apt -y update",
            # "sudo apt -y upgrade",
             "sudo apt -y install mysql-client",
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
    Name = "Bastion B"
  }
}



# if manually setting ip address
resource "aws_network_interface" "bastion-a" {
  subnet_id   = aws_subnet.public_a.id
  security_groups = [aws_security_group.bastion-sg.id]
  tags = {
    Name = "nginx a network interface"
  }
}


resource "aws_network_interface" "bastion-b" {
  subnet_id   = aws_subnet.public_b.id
  security_groups = [aws_security_group.bastion-sg.id]
  tags = {
    Name = "nginx b network interface"
  }
}

# open all egresss
resource "aws_security_group" "bastion-sg" {

   tags = {
       Name = "bastion-sg"
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


