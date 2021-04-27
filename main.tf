provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "vpc_bva_dev" {
  cidr_block           = "172.16.0.0/16"
  enable_dns_hostnames = true
  tags = {
    "env" = "dev"
  }
}

resource "aws_subnet" "subnet_bva_public_a" {
  vpc_id     = aws_vpc.vpc_bva_dev.id
  cidr_block = "172.16.10.0/24"
    availability_zone = "us-east-1a"
}

resource "aws_subnet" "subnet_bva_public_b" {
  vpc_id     = aws_vpc.vpc_bva_dev.id
  cidr_block = "172.16.11.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_subnet" "subnet_bva_private_a" {
  vpc_id     = aws_vpc.vpc_bva_dev.id
  cidr_block = "172.16.20.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "subnet_bva_private_b" {
  vpc_id     = aws_vpc.vpc_bva_dev.id
  cidr_block = "172.16.21.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_instance" "bvasvr001" {
  ami = var.image
  instance_type = var.vm-type
  associate_public_ip_address = true
  user_data = "${file("bva-init.sh")}"
  subnet_id = aws_subnet.subnet_bva_public_a.id
  tags = {
    "env" = "dev"
  }
}

# resource "aws_db_instance" "dbbvasvr001" {
#   allocated_storage = 10
#   engine = "mysql"
#   engine_version = "5.7"
#   instance_class = "db.t2.micro"
#   name = "db-bva"
#   username = "brunobva"
#   password = "test@1234"
#   skip_final_snapshot = true
#   db_subnet_group_name = aws_db_subnet_group.db_subnet_bva.id
# }

resource "aws_db_subnet_group" "db_subnet_bva" {
  name = "db_subnet_bva"
  subnet_ids = [aws_subnet.subnet_bva_private_a.id, aws_subnet.subnet_bva_private_b.id]
}

resource "aws_eip" "ip-bva" {
  vpc = true
  depends_on = [
    aws_internet_gateway.bva_igw
  ]
}

resource "aws_internet_gateway" "bva_igw" {
  vpc_id = aws_vpc.vpc_bva_dev.id
}

resource "aws_nat_gateway" "bva-nat-gw" {
  allocation_id = aws_eip.ip-bva.id
  subnet_id = aws_subnet.subnet_bva_public_a.id

  depends_on = [ aws_internet_gateway.bva_igw ]
}

resource "aws_route_table" "bva-router"{  
  vpc_id = aws_vpc.vpc_bva_dev.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.bva_igw.id
  }
}

resource "aws_route_table_association" "bva-routetable" {
    subnet_id = aws_subnet.subnet_bva_public_a.id
    route_table_id = aws_route_table.bva-router.id 
}

output Public_IP {
  value = aws_instance.bvasvr001.public_ip
}

output Public_DNS {
  value = aws_instance.bvasvr001.public_dns
}