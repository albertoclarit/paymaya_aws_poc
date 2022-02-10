
resource "aws_instance" "bastion-a" {
  ami = "ami-055d15d9cfddf7bd3" # ubuntu
  instance_type = "t2.micro"

  availability_zone = "${var.aws_region}a"


  vpc_security_group_ids = ["${aws_security_group.bastion-sg.id}"]
  // https://serverfault.com/questions/931609/terraform-how-to-reference-the-subnet-created-in-the-vpc-module
  subnet_id = module.vpc.public_subnets[0]

  credit_specification {
    cpu_credits = "unlimited"
  }

  key_name= "aws_key"

  tags = {
    Name = "Bastion A"
  }
}



# open all egresss
resource "aws_security_group" "bastion-sg" {

   tags = {
       Name = "bastion-sg"
     }
  name= "bastion-sg"

  vpc_id      = module.vpc.vpc_id
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


