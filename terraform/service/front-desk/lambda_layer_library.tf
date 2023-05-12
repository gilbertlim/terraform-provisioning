resource "aws_lambda_layer_version" "lib" {
  filename            = "${local.tags.Resource}-lib.zip"
  layer_name          = "import_packages"
  compatible_runtimes = ["python3.9"]
}

data "archive_file" "lib" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/library"
  output_path = "${path.module}/${local.tags.Resource}-lib.zip"
}
