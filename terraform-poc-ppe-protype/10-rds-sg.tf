resource "aws_security_group" "mysql-sg" {

  vpc_id      = aws_vpc.main.id

  tags = {
     Name = "mysql-sg"
   }
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
     from_port        = 3306
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     protocol         = "tcp"
     security_groups  = []
     self             = false
     to_port          = 3306
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


