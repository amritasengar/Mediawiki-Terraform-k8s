resource "aws_vpc" "mediwiki" {
  cidr_block = "10.0.0.0/16"
	tags = {
    Name = "Mediawiki"
  }

}


resource "aws_subnet" "mediawiki_subnet_public_1" {
  vpc_id     = "${aws_vpc.mediawiki.id}"
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "PublicSubent1"
  }
}


resource "aws_subnet" "mediawiki_subnet_private_1"{
	vpc_id	= "${aws_vpc.mediawiki.id}"
	cidr_block	= "10.0.2.0/24"
	tags = {
		Name = "Private Subnet 1"

	}
}
 

resource "aws_subnet" "mediawiki_subnet_private_2"{
	vpc_id	= "${aws_vpc.mediawiki.id}"
	cidr_block	= "10.0.3.0/24"
	tags = {
		Name = "Private Subnet 2"

	}
}
 

resource "aws_security_group" "master-security-group"{
	name	= "master-sg"
	description =	"Security from Kube master"

	ingress {

		from_port		= 0
		to_port			= 0
		protocol		= "-1"
		cidr_blocks	=  [0.0.0.0/0]
		self	= true
	}

	egress {

		from_port		= 0
		to_port			= 0
		protocol		= "-1"
		cidr_blocks	=  [0.0.0.0/0]
		self	= true
	}
	tags = {
		Name = "master-sg"
	}
}

resource "aws_internet_gateway" "mediawiki-igw" {
  vpc_id = "${aws_vpc.mediawiki.id}"

  tags = {
    Name = "Main-k8s"
  }
}

resource "aws_route_table" "mediawiki-rtb" {
  vpc_id = "${aws_vpc.mediawiki.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.mediawiki-igw.id}"
  }


  tags = {
    Name = "k8s-rtb"
  }
}


resource "aws_route_table_association" "pub-custom-rtb" {
  subnet_id      = "${aws_subnet.mediawiki_subnet_public_1.id}"
  route_table_id = "${aws_route_table.mediawiki-rtb.id}"
}

»
