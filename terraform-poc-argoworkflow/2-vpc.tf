# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest

/* required by nat gatewat */


locals {
  cluster_name = "sample-eks-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

resource "aws_eip" "nat" {
  count = 1

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

 # One NAT Gateway for all
 # to save money

  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false

  # for ec2 instances
  enable_dns_hostnames = true
  reuse_nat_ips       = true                    # <= Skip creation of EIPs for the NAT Gateways
  external_nat_ip_ids = "${aws_eip.nat.*.id}"   # <= IPs specified here as input to the module

 tags = {
     "kubernetes.io/cluster/${local.cluster_name}" = "shared"
   }

   public_subnet_tags = {
     "kubernetes.io/cluster/${local.cluster_name}" = "shared"
     "kubernetes.io/role/elb"                      = "1"
   }

   private_subnet_tags = {
     "kubernetes.io/cluster/${local.cluster_name}" = "shared"
     "kubernetes.io/role/internal-elb"             = "1"
   }
}


