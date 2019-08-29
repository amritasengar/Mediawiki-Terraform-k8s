
#create the networking resources in aws


#VPC-resource

resource "aws_vpc" "k8s-vpc" {
  cidr_block = "${var.vpc_cidr}"
  # to use the internal vpc resolution

  enable_dns_support = true
  enable_dns_hostnames = true


  tags = {
    name = "k8s-vpc" 
 }
}


#Creating internet gateway
resource "aws_internet_gateway" "mediawiki_internet_gateway" {
  vpc_id = "${aws_vpc.k8s-vpc.id}"

  tags {
    Name = "mediawiki_internet_gateway"
  }
}

# creating Route-table


resource "aws_route_table" "public_subnet_route_table" {
  vpc_id = "${aws_vpc.k8s-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.mediawiki_internet_gateway.id}"
  }
}


#Creating public_subnet1 
resource "aws_subnet" "public_subnet1" {
  vpc_id            = "${aws_vpc.k8s-vpc.id}"
  cidr_block        = "${element(var.public_subnet_cidr_list,0)}"
  availability_zone = "${element(data.aws_availability_zones.azs.names,0)}"

  tags {
    Name = "public_subnet1"
  }
}

#RouteTable association for public_subnet1
resource "aws_route_table_association" "public_subnet_association_1" {
  subnet_id      = "${aws_subnet.public_subnet1.id}"
  route_table_id = "${aws_route_table.public_subnet_route_table.id}"
}

#Creating private_subnet1
resource "aws_subnet" "private_subnet1" {
  vpc_id            = "${aws_vpc.k8s-vpc.id}"
  cidr_block        = "${element(var.private_subnet_cidr_list,0)}"
  availability_zone = "${element(data.aws_availability_zones.azs.names,0)}"

  tags {
    Name = "private_subnet1"
  }
}

# Creating Private Subnet2
resource "aws_subnet" "private_subnet2" {
  vpc_id            = "${aws_vpc.k8s-vpc.id}"
  cidr_block        = "${element(var.private_subnet_cidr_list,1)}"
  availability_zone = "${element(data.aws_availability_zones.azs.names,1)}"

  tags {
    Name = "private_subnet2"
  }
}


# Creating Security Group for Mediawiki_webservers
resource "aws_security_group" "webserver_sg" {
  name        = "webserver_sg"
  description = "Allow inbound traffic from bastion host"
  vpc_id      = "${aws_vpc.k8s-vpc.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = ["${var.alb_sg}"]
  }
    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

