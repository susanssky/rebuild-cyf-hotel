resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "eu-west-2a"
  tags = {
    Name = "${var.env_prefix}-subnet1"
  }
}
resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = "eu-west-2b"
  tags = {
    Name = "${var.env_prefix}-subnet2"
  }
}

resource "aws_db_subnet_group" "subnet-group" {
  subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  tags = {
    Name = "${var.env_prefix}-subnet-group"
  }
}

resource "aws_route_table" "route-table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.env_prefix}-rtb"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.env_prefix}-igw"
  }
}

# resource "aws_route_table_association" "a-rtb-subnet-1" {
#   subnet_id      = aws_subnet.subnet-1.id
#   route_table_id = aws_route_table.route-table.id
# }
# resource "aws_route_table_association" "a-rtb-subnet-2" {
#   subnet_id      = aws_subnet.subnet-2.id
#   route_table_id = aws_route_table.route-table.id
# }

# =======================terraform plan=====================
locals {
  subnet_ids = [
    aws_subnet.subnet1.id,
    aws_subnet.subnet2.id,
  ]
}
resource "aws_route_table_association" "rtb-subnet" {
  for_each = { for idx, id in local.subnet_ids : idx => id }

  subnet_id      = each.value
  route_table_id = aws_route_table.route-table.id
}
# =======================terraform plan=====================

