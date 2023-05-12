module "vpc" {
  source = "../_module/vpc"

  tags            = module.tags.tags
  vpc_id          = var.vpc_id
  private_subnets = module.subnet.private_subnets
}

