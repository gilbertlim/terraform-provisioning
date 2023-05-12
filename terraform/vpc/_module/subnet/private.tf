resource "aws_subnet" "this" {
  vpc_id = var.vpc_id

  for_each = var.private_subnets

  availability_zone = each.value.availability_zone
  cidr_block        = each.value.cidr_block

  tags = {
    Name = "sbn-${var.tags.Owner}-pri-az${each.key}"
  }
}

resource "aws_route_table" "this" {
  vpc_id = var.vpc_id

  for_each = var.private_subnets

  tags = {
    Name = "rt-${var.tags.Owner}-pri-az${each.key}"
  }
}

resource "aws_route_table_association" "this" {
  count = length(aws_subnet.this)

  route_table_id = values(aws_route_table.this)[count.index].id
  subnet_id      = values(aws_subnet.this)[count.index].id
}

resource "aws_vpc_endpoint_route_table_association" "s3" {
  for_each = toset(data.aws_route_tables.add_vpce_s3.ids)

  route_table_id  = each.value
  vpc_endpoint_id = var.vpc_endpoint_s3_id
}

data "aws_route_tables" "add_vpce_s3" {
  filter {
    name   = "tag:Name"
    values = ["rt-${var.tags.Owner}-pri-az2a", "rt-${var.tags.Owner}-pri-az2c"]
  }
}
