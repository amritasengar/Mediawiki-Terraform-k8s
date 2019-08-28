
#--------create the networking resources in aws-------


#-----VPC-resource-----
resource "aws_vpc" "k8s-vpc" {
  cidr_block = "${var.vpc_cidr}"
  # ---------to use the internal vpc resolution-----------
  enable_dns_support = true
  enable_dns_hostnames = true


  tags{
    name = "k8s-vpc" 
 }
}


#-----internet gateway---

resource "aws_internet_gateway" "k8s-igw" {
  vpc_id = "${aws_vpc.k8s-vpc.id}"

  tags = {
    Name = "k8s-igw"
  }
}


# -----Route-table-----

