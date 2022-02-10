# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#db_subnet_group_name
resource "aws_db_instance" "mysql" {

  identifier = "mysql"

  tags = {
    name = "mysql-db"
  }
  allocated_storage     = 10
  max_allocated_storage = 50
  apply_immediately    = true
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "mydb"
  username             = "root"
  password             = "${var.mysql_password}"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true

  multi_az = true
  vpc_security_group_ids = [aws_security_group.mysql-sg.id]
  db_subnet_group_name = "${aws_db_subnet_group.db-subnet.name}"
}
