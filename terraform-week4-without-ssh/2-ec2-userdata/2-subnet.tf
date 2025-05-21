# data.aws_availability_zones.available.names[count.index]:
# "names" = tolist([
#   "eu-west-2a",
#   "eu-west-2b",
#   "eu-west-2c",
# ])

resource "aws_subnet" "public_subnet" {
  count                   = var.subnet_number
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.${(count.index + 1) * 10}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.week_prefix}-public-subnet${count.index + 1}"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.week_prefix}-igw"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.week_prefix}-public-rtb"
  }
}
# =======================terraform plan=====================

resource "aws_route_table_association" "rtb_public_subnet" {
  for_each  = { for idx, id in aws_subnet.public_subnet[*].id : idx => id }
  subnet_id = each.value

  route_table_id = aws_route_table.public_route_table.id
}

# =======================terraform plan=====================
