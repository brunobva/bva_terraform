# Create a VPC
resource "aws_vpc" "bvaVpc" {
  cidr_block           = var.bvaVpcCIDR
  instance_tenancy     = var.instanceTenancy
  enable_dns_hostnames = var.dnsHostNames

  tags = {
    Name = "BVA VPC"
    Env  = "BVA Dev"
  }
}
resource "aws_subnet" "bvaPubSubnet" {
  vpc_id                  = aws_vpc.bvaVpc.id
  cidr_block              = var.bvaPubCIDR
  map_public_ip_on_launch = var.mapPublicIP
  availability_zone       = var.availabilityZone

  tags = {
    Name = "BVA Public Subnet"
  }
}

resource "aws_internet_gateway" "bvaIGW" {
  vpc_id = aws_vpc.bvaVpc.id

  tags = {
    Name = "BVA Internet Gateway"
  }
}

resource "aws_route_table" "bvaRoutePublic" {
  vpc_id = aws_vpc.bvaVpc.id
  route {
    cidr_block = var.publicdestCIDRblock
    gateway_id = aws_internet_gateway.bvaIGW.id
  }
  tags = {
    "Name" = "Public Route Table for BVA"
  }
}

resource "aws_route_table_association" "bvaRoutePublic" {
  subnet_id      = aws_subnet.bvaPubSubnet.id
  route_table_id = aws_route_table.bvaRoutePublic.id
}