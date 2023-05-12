module "s3" {
  source = "../../_module/log"

  tags = module.tags.tags
}
