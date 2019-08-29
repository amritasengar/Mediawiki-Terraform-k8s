

# Outputting the mediawiki_vpc_id to use as a parameter in other modules.
output "mediawiki_vpc_id" {
  value = "${aws_vpc.k8s-vpc.id}"
}

# Outputting the public_subnet_1_id to use as a parameter in other modules.
output "public_subnet_1_id" {
  value = "${aws_subnet.public_subnet1.id}"
}


# Outputting the private_subnet_1_id to use as a parameter in other modules.
output "private_subnet_1_id" {
  value = "${aws_subnet.private_subnet1.id}"
}

# Outputting the private_subnet_2_id to use as a parameter in other modules.
output "private_subnet_2_id" {
  value = "${aws_subnet.private_subnet2.id}"
}


output "master-sg" {
  value = "${aws_security_group.master-sg.id}"
}
 
