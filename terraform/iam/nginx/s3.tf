module "s3" {
  source = "../_module/s3"

  tags = module.tags.tags

  role = module.ec2.aws_iam_role.id

  bucket = [
    data.aws_s3_bucket.this.arn,
    join("", [data.aws_s3_bucket.this.arn, "/*"])
  ]
}

data "aws_s3_bucket" "this" {
  bucket = "${module.tags.tags.Owner}-${module.tags.tags.Resource}-${module.tags.tags.Purpose}"
}
