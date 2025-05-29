# data.aws_availability_zones.available.names[count.index]:
# "names" = tolist([
#   "eu-west-2a",
#   "eu-west-2b",
#   "eu-west-2c",
# ])

resource "aws_subnet" "public-subnet" {
  count                   = var.subnet_number
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.${(count.index + 1) * 10}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.week_prefix}-public-subnet${count.index + 1}"
  }
}
resource "aws_subnet" "private-subnet" {
  count                   = var.subnet_number
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.${(count.index + 3) * 10}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.week_prefix}-private-subnet${count.index + 1}"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.week_prefix}-igw"
  }
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.week_prefix}-public-rtb"
  }
}
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.week_prefix}-private-rtb"
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

resource "aws_route_table_association" "rtb-public-subnet" {
  for_each  = { for idx, id in aws_subnet.public-subnet[*].id : idx => id }
  subnet_id = each.value

  route_table_id = aws_route_table.public-route-table.id
}
resource "aws_route_table_association" "rtb-private-subnet" {
  for_each  = { for idx, id in aws_subnet.private-subnet[*].id : idx => id }
  subnet_id = each.value

  route_table_id = aws_route_table.private-route-table.id
}
# =======================terraform plan=====================

# data "aws_route_table" "selected" {
#   subnet_id = "subnet-0c82752aaddd68b1d"
# }

# output "view" {
#   value = data.aws_route_table.selected
# }
