#VPC
resource "aws_vpc" "vpc_aws" {
    cidr_block       = "${var.cidr_vpc}"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false"
    tags = {
        Name = "${var.environment_tag}"
    }
}

#Private Subnets
resource "aws_subnet" "subnet-private" {
    vpc_id = "${aws_vpc.vpc_aws.id}"
    map_public_ip_on_launch = "false"
    cidr_block = "${var.cidr_subnet}"
    tags = {
        Name = "${var.environment_tag}"
    }
}

#Public Subnets
resource "aws_subnet" "subnet-public" {
    vpc_id = "${aws_vpc.vpc_aws.id}"
    map_public_ip_on_launch = "true"
    cidr_block = "${var.cidr_subnet_public}"
    tags = {
        Name = "${var.environment_tag}"
    }
}



#Internet Getway
resource "aws_internet_gateway" "gw" {
    vpc_id = "${aws_vpc.vpc_aws.id}"

    tags = {
        Name = "${var.environment_tag}"
    }
}

#Route tables
resource "aws_route_table" "public_route" {
    vpc_id = "${aws_vpc.vpc_aws.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gw.id}"
    }
}

resource "aws_route_table" "private_route" {
    vpc_id = "${aws_vpc.vpc_aws.id}"
    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.instance_nat.id}"
    }
}

#Route public 
resource "aws_route_table_association" "subnet-public" {
  subnet_id      = "${aws_subnet.subnet-public.id}"
  route_table_id = "${aws_route_table.public_route.id}"
}
resource "aws_route_table_association" "subnet-private" {
  subnet_id      = "${aws_subnet.subnet-private.id}"
  route_table_id = "${aws_route_table.private_route.id}"
}