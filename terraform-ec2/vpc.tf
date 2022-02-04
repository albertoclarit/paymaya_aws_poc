# Create a VPC
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc#enable_dns_hostnames
# https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html#vpc-igw-internet-access
# Availability Zones are automatically selected if not specified
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
# see https://nickcharlton.net/posts/terraform-aws-vpc.html
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
   tags = {
      Name = "main"
    }

}

