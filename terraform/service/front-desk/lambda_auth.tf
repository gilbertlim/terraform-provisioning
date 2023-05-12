resource "aws_lambda_function" "auth" {
  function_name = "${local.tags.Owner}-${local.tags.Resource}-auth-fn"

  runtime       = "python3.9"
  architectures = ["x86_64"]
  role          = data.aws_iam_role.auth.arn

  package_type = "Zip"
  handler      = "index.handler"
  filename     = "${local.tags.Resource}-auth.zip"

  memory_size = "128"

  layers = [aws_lambda_layer_version.lib.arn]

  timeout = 300 # 5min

  description = "Lambda function to access bastion (media-platform only)"

}

data "aws_iam_role" "auth" {
  name = "${local.tags.Owner}-${local.tags.Resource}-auth-role"
}

resource "aws_lambda_function_url" "this" {
  function_name      = aws_lambda_function.auth.function_name
  authorization_type = "NONE"
}

data "archive_file" "auth" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/python/auth"
  output_path = "${path.module}/${local.tags.Resource}-auth.zip"
}
