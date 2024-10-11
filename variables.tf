variable "region" {
   default = "ap-south-1"
}
variable "ami" {
    default = "ami-0dee22c13ea7a9a67"
}

variable "instance_type" {
    default = "t2.micro"
}

variable "key-name" {
    default = "Mumbai"
}

variable "vpc_cidr" {
    default = "10.1.0.0/16"
}

variable "subnet_cidr" {
    default = "10.1.1.0/24"
}