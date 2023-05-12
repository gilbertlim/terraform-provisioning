module "ec2" {
  source = "../_module/ec2"

  tags = module.tags.tags
}
