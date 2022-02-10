variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "ap-southeast-1"
}


variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr_a" {
    description = "CIDR for the Public Subnet A"
    default = "10.0.0.0/24"
}

variable "public_subnet_cidr_b" {
    description = "CIDR for the Public Subnet B"
    default = "10.0.2.0/24"
}

variable "private_subnet_cidr_a" {
    description = "CIDR for the Private Subnet A"
    default = "10.0.1.0/24"
}

variable "private_subnet_cidr_b" {
    description = "CIDR for the Private Subnet B"
    default = "10.0.3.0/24"
}

variable "mysql_password" {
    description = "MySQL Password"
    default = "coffeemug143@!"
}