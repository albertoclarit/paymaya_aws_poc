# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest

/* required by nat gatewat */

resource "aws_eip" "nat" {
  count = 3

  vpc = true
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "main-vpc"
  cidr = "${var.vpc_cidr}"

  azs              = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  private_subnets  = ["${var.private_subnet_cidr_a}", "${var.private_subnet_cidr_b}", "${var.private_subnet_cidr_c}"]
  public_subnets   = ["${var.public_subnet_cidr_a}", "${var.public_subnet_cidr_b}", "${var.public_subnet_cidr_c}"]
  database_subnets = ["${var.db_subnet_cidr_a}", "${var.db_subnet_cidr_b}", "${var.db_subnet_cidr_c}"]

   /* intra_subnets       = ["10.0.51.0/24", "10.0.52.0/24", "10.0.53.0/24"] */
   // these are subnets with no internet routing


  // create db subnet group
  create_database_subnet_group    = true

  enable_vpn_gateway = true

 # One NAT Gateway per subnet (default behavior)
 # very expensive... we can do single nat gateway

  enable_nat_gateway = true
  single_nat_gateway = false
  one_nat_gateway_per_az = false

  reuse_nat_ips       = true                    # <= Skip creation of EIPs for the NAT Gateways
  external_nat_ip_ids = "${aws_eip.nat.*.id}"   # <= IPs specified here as input to the module

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}