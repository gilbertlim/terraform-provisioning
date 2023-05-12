module "nat_gateway" {
  source = "../../_module/nat_gateway"

  public_subnet_to_add_nat = data.aws_subnet.to_add_nat
  tags                     = module.tags.tags
}

data "aws_subnet" "to_add_nat" {
  tags = {
    Name = "sbn-${module.tags.tags.Owner}-pub-az2c"
  }
}
