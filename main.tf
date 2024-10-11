resource "aws_vpc" "WebClues_vpc" {
  cidr_block = var.vpc_cidr
   tags = {
      Name = "WebClues-VPC"
    }
}

resource "aws_subnet" "WebClues_subnet" {
  vpc_id     = "${aws_vpc.WebClues_vpc.id}"
  cidr_block = var.subnet_cidr
  map_public_ip_on_launch = "true"
  tags = {
    Name = "WebClues-subnet"
  }
}


resource "aws_internet_gateway" "WebClues_igw" {
  vpc_id =  "${aws_vpc.WebClues_vpc.id}"

  tags = {
    Name = "WebClues-igw"
  }
}

resource "aws_route_table" "WebClues_rt" {
  vpc_id =  "${aws_vpc.WebClues_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.WebClues_igw.id}"
  }

  tags = {
    Name = "WebClues-rt"
  }
}


resource "aws_route_table_association" "WebClues_rt_associate" {
  subnet_id      = "${aws_subnet.WebClues_subnet.id}"
  route_table_id = "${aws_route_table.WebClues_rt.id}"
}

resource "aws_security_group" "WebClues_sg" {
  name        = "WebClues-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = "${aws_vpc.WebClues_vpc.id}"

  tags = {
    Name = "WebClues-sg"
  }
}

resource "aws_instance" "WebClues-ec2" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key-name
    subnet_id    ="${aws_subnet.WebClues_subnet.id}" 
    vpc_security_group_ids  = [aws_security_group.WebClues_sg.id]
    
user_data = <<-EOF
    package_update: true
    package_upgrade: true
    packages:
      - nginx
    runcmd:
      - systemctl start nginx
      - systemctl enable nginx
   EOF
}

resource "aws_vpc_security_group_ingress_rule" "ingress-sg-ssh" {
  security_group_id = "${aws_security_group.WebClues_sg.id}"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
resource "aws_vpc_security_group_ingress_rule" "ingress-sg-http" {
  security_group_id = "${aws_security_group.WebClues_sg.id}"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "egree-sg" {
  security_group_id = "${aws_security_group.WebClues_sg.id}"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

