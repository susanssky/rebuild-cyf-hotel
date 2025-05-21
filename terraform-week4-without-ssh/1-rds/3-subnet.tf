# data.aws_availability_zones.available.names[count.index]:
# "names" = tolist([
#   "eu-west-2a",
#   "eu-west-2b",
#   "eu-west-2c",
# ])


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



resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.week_prefix}-private-rtb"
  }
}

# =======================terraform plan=====================


resource "aws_route_table_association" "rtb-private-subnet" {
  for_each  = { for idx, id in aws_subnet.private-subnet[*].id : idx => id }
  subnet_id = each.value

  route_table_id = aws_route_table.private-route-table.id
}
# =======================terraform plan=====================

