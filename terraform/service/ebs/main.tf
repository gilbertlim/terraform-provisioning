module "ebs" {
  source = "../_module/ebs"

  availability_zone = "ap-northeast-2a"
  size              = "20"
  tags              = module.tags.tags
  type              = "gp2"
  instance_id       = data.aws_instance.nginx.id
}

data "aws_instance" "nginx" {
  filter {
    name   = "tag:Name"
    values = ["${module.tags.tags.Owner}-nginx"]
  }
}
