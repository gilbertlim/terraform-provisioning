module "tags" {
  source = "../../../modules/tags"

  resource = "nginx"
  purpose  = "accesslog"
}
