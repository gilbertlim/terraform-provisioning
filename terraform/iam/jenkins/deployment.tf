module "ecs" {
  source = "../_module/deployment"

  tags = module.tags.tags
}
