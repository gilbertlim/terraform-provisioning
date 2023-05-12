resource "aws_eip" "this" {
  vpc = true

  tags = {
    Name = "${var.tags.Owner}-nat-eip"
  }
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = var.public_subnet_to_add_nat.id

  tags = {
    Name = "nat-${var.tags.Owner}-pub-az${substr(var.public_subnet_to_add_nat.availability_zone, 13, 2)}"
  }
}

resource "aws_route" "add_nat" {
  for_each = toset(data.aws_route_tables.add_vpce_s3.ids)

  route_table_id         = each.value
  nat_gateway_id         = aws_nat_gateway.this.id
  destination_cidr_block = "0.0.0.0/0"
}

data "aws_route_tables" "add_vpce_s3" {
  filter {
    name   = "tag:Name"
    values = ["rt-${var.tags.Owner}-pri-az2a", "rt-${var.tags.Owner}-pri-az2c"]
  }
}
