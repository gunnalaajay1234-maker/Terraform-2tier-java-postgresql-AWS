
########################
# VPC
########################
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "2Tier-java"
  }
}

########################
# Subnets
########################
resource "aws_subnet" "app_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = { Name = "AppSubnet" }
  depends_on = [ aws_vpc.main ]
}

resource "aws_subnet" "db_subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-1b"
  tags = { Name = "DBSubnet1" }
  depends_on = [ aws_vpc.main ]
}

resource "aws_subnet" "db_subnet_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-south-1c"
  tags = { Name = "DBSubnet2" }
  depends_on = [ aws_vpc.main ]
}

########################
# Internet Gateway
########################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "MyAppIGW" }
  depends_on = [ aws_vpc.main ]
}

########################
# Route Tables
########################

# Public Route Table (App)
resource "aws_route_table" "apprt" {
  vpc_id = aws_vpc.main.id
  depends_on = [ aws_internet_gateway.igw ]

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = { Name = "apprt" }
}

resource "aws_route_table_association" "app_assoc" {
  subnet_id      = aws_subnet.app_subnet.id
  route_table_id  = aws_route_table.apprt.id
}

# Private Route Table (DB)
resource "aws_route_table" "dbrt" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "dbrt" }
}

resource "aws_route_table_association" "db1" {
  subnet_id     = aws_subnet.db_subnet_1.id
  route_table_id = aws_route_table.dbrt.id
}

resource "aws_route_table_association" "db2" {
  subnet_id     = aws_subnet.db_subnet_2.id
  route_table_id = aws_route_table.dbrt.id
}




