resource "aws_rds_cluster" "aurora-mysql" {
  cluster_identifier      = "aurora-mysql"
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.03.2"
  availability_zones      = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  database_name           = "mydb"
  master_username         = "root"
  master_password         = "${var.mysql_password}"

  db_subnet_group_name = "${aws_db_subnet_group.db-subnet.name}"
  vpc_security_group_ids = [aws_security_group.mysql-sg.id]
  engine_mode            = "serverless"  /* default to provisioned */
  apply_immediately = true
  backup_retention_period = 5
 # preferred_backup_window = "07:00-09:00"
 # final_snapshot_identifier = "ci-aurora-cluster-backup"
  skip_final_snapshot = true
}


/*
 only used in engine_mode=provisioned
resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = 2
  identifier         = "aurora-cluster-mysql-${count.index}"
  cluster_identifier = aws_rds_cluster.aurora-mysql.id
  instance_class     = "db.t2.micro"
  engine             = aws_rds_cluster.aurora-mysql.engine
  engine_version     = aws_rds_cluster.aurora-mysql.engine_version
}
*/