resource "aws_vpc" "platform_vpc" {
  cidr_block           = "${var.vpc_cidr_block}"
  instance_tenancy     = "${var.instance_tenancy}"
  enable_dns_support   = "${var.dns_support}"
  enable_dns_hostnames = "${var.dns_host_names}"

  tags {
    Name = "platform_vpc"
  }
}

resource "aws_network_acl" "platform_public_nacl" {
  vpc_id     = "${aws_vpc.platform_vpc.id}"
  subnet_ids = ["${aws_subnet.webserver_subnet.id}"]

  # allow port 22
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "${var.ingress_home_cidr}"
    from_port  = 22
    to_port    = 22
  }

  # allow port 22
  ingress {
    protocol   = "tcp"
    rule_no    = 101
    action     = "allow"
    cidr_block = "178.143.34.185/32"
    from_port  = 22
    to_port    = 22
  }

  # allow ingress ephemeral ports 
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "${var.whitelist_world}"
    from_port  = 1024
    to_port    = 65535
  }

  # allow egress ephemeral ports
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "${var.whitelist_world}"
    from_port  = 0
    to_port    = 65535
  }

  tags {
    Name = "platform_public_nacl"
  }
}

resource "aws_internet_gateway" "platform_igw" {
  vpc_id = "${aws_vpc.platform_vpc.id}"

  tags {
    Name = "platform_igw"
  }
}

resource "aws_route_table" "platform_public_route" {
  vpc_id = "${aws_vpc.platform_vpc.id}"

  tags {
    Name = "platform_public_route"
  }
}

resource "aws_route" "platform_internet_access" {
  route_table_id         = "${aws_route_table.platform_public_route.id}"
  destination_cidr_block = "${var.whitelist_world}"
  gateway_id             = "${aws_internet_gateway.platform_igw.id}"
}
