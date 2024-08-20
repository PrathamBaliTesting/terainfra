provider "aws" {
  region=var.region
  
}

#testing
#Generating of VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  
  tags={
    Name="prod_Bali_vpc"
  }
}

#Generating of a Public Subnet
resource "aws_subnet" "public_subnet" {
  
  vpc_id = aws_vpc.main.id
  cidr_block = var.subnet_public_cidrs
  

  tags={
    Name="prod Public Subnet"
  }
}

#Generating of Private Subnet
resource "aws_subnet" "private_subnet" {
  
  vpc_id = aws_vpc.main.id
  cidr_block = var.subnet_private_cidrs
  
  tags={
    Name="prod Private Subnet"
  }
}

#Generating of public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "prod Public Route Table"
  }
  
}

#Association of Route Table with Public Subnet 
resource "aws_route_table_association" "public_subnets_asso" {
  
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
  
}

#generating private route table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    Name = "prod Private Route Table"
  }
  
}

#Association of Route Table with Public Subnet 
resource "aws_route_table_association" "private_subnets_asso" {
  
  subnet_id = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
  
}
#Generating Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags={
    Name="prod_my_vpc_IG"
  }
  
}

#Generating Elastic IP
resource "aws_eip" "eip" {
  domain = "vpc"

  tags = {
    Name = "prod_Bali_elastic"
  }
  
}

#Allocation of NAT Gateway
resource "aws_nat_gateway" "ngw" {
    allocation_id=aws_eip.eip.id
    subnet_id=aws_subnet.private_subnet.id

    tags = {
      Name= "prod_nat_gateway_bali"
    }

    depends_on = [ aws_internet_gateway.main ]
  
}

#Generating of Network ACLs
resource "aws_network_acl" "nacls" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "prod_Bali_NACLs"
  }
  
}

#Allocation of NACLs with Public Subnet ID
resource "aws_network_acl_association" "nacls_asso" {
  network_acl_id = aws_network_acl.nacls.id
  subnet_id = aws_subnet.public_subnet.id  
  
}



#Generating of SSH and HTTP Secuirty Group
resource "aws_security_group" "http_access" {
  vpc_id = aws_vpc.main.id
  name   = "prod_http_access"
  description = "Secuirty Groups Modules"

  #This is For SSH
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  #This is For Http
  ingress {
    description = "Http Acess"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}