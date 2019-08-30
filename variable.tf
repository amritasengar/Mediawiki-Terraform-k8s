
# Region variable to hold the region to create the infrastructure. Default value is us-east-1.
variable "region" {
  default = "us-east-1"
}

# VPC CIDR to create the VPC. Default value is 10.0.0.0/16
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

# CIDR ranges for Public subnets. Takes in List. Default value is 10.0.1.0/24
variable "public_subnet_cidr_list" {
  type    = "list"
  default = ["10.0.1.0/24"]
}

# CIDR ranges for Private subnets. Takes in List.
variable "private_subnet_cidr_list" {
  type    = "list"
  default = ["10.0.2.0/24", "10.0.3.0/24"]
}

# Using the aws_availaibility_zones data source to get the list of availability zoned in the provided region.
data "aws_availability_zones" "azs" {}

variable "public_key_path" {
  description = "Your public key path"
  default     = "~/.ssh/id_rsa.pub"
}

variable "private_key_path" {
  description = "Your private key path"
  default     = "~/.ssh/id_rsa"
}

variable "aws_key_name" {
  description = "Key pair name to use for instances"
  default     = "mediawiki-key"
}

variable "aws_instance_type" {
  default = "t2.medium"
}
