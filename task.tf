provider "aws" {
 region = "ap-south-1"
}

resource "aws_vpc" "main" {
 cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
 cidr_block = "10.0.1.0/24"
 vpc_id     = aws_vpc.main.id
}

resource "aws_route_table" "main" {
 vpc_id = aws_vpc.main.id

 route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
 }
}

resource "aws_internet_gateway" "main" {
 vpc_id = aws_vpc.main.id
}

resource "aws_security_group" "main" {
 name        = "main"
 description = "Allow all inbound traffic"
 vpc_id      = aws_vpc.main.id

 ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
 }
}

resource "aws_instance" "main" {
 ami           = "ami-0a0f1259dd1c90938" 
 instance_type = "t2.micro"

 vpc_security_group_ids = [aws_security_group.main.id]
 subnet_id              = aws_subnet.main.id

 associate_public_ip_address = true
}