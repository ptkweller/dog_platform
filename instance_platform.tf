resource "aws_subnet" "webserver_subnet" {
  vpc_id                  = "${aws_vpc.platform_vpc.id}"
  cidr_block              = "${var.webserver_subnet_cidr}"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-1c"

  tags = {
    Name = "webserver_subnet"
  }
}

resource "aws_security_group" "webserver_security_group" {
  vpc_id      = "${aws_vpc.platform_vpc.id}"
  name        = "webserver_security_group"
  description = "webserver_security_group"

  ingress {
    cidr_blocks = "${var.ingress_cidr_list}"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  egress {
    cidr_blocks = "${var.egress_cidr_list}"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
  }

  tags = {
    Name = "webserver_security_group"
  }
}

resource "aws_instance" "webserver" {
  ami                    = "${var.ami_id}"
  instance_type          = "${var.ami_size}"
  vpc_security_group_ids = ["${aws_security_group.webserver_security_group.id}"]
  subnet_id              = "${aws_subnet.webserver_subnet.id}"
  key_name               = "platform_instances"

  tags = {
    Name = "webserver"
  }
}

resource "aws_route_table_association" "webserver_route_table_association" {
  subnet_id      = "${aws_subnet.webserver_subnet.id}"
  route_table_id = "${aws_route_table.platform_public_route.id}"
}
