module "subnet" {
  source = "../_module/subnet"

  tags               = module.tags.tags
  vpc_id             = var.vpc_id
  private_subnets    = var.private_subnets
  vpc_endpoint_s3_id = module.vpc.vpc_endpoint_s3_id
}
