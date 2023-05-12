resource "aws_lambda_function" "main" {
  function_name = "${local.tags.Owner}-${local.tags.Resource}-main-fn"

  runtime       = "python3.9"
  architectures = ["x86_64"]
  role          = data.aws_iam_role.main.arn

  package_type = "Zip"
  handler      = "index.handler"
  filename     = "${local.tags.Resource}-main.zip"

  memory_size = "128"

  layers = [aws_lambda_layer_version.lib.arn]

  timeout = 300 # 5min

  description = "Lambda function to access bastion (media-platform only)"
}

data "aws_iam_role" "main" {
  name = "${local.tags.Owner}-${local.tags.Resource}-main-role"
}

data "archive_file" "main" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/python/main"
  output_path = "${path.module}/${local.tags.Resource}-main.zip"
}
