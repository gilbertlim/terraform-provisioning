resource "aws_lambda_function" "schedule" {
  function_name = "${local.tags.Owner}-${local.tags.Resource}-schedule-fn"

  runtime       = "python3.9"
  architectures = ["x86_64"]
  role          = data.aws_iam_role.main.arn

  package_type = "Zip"
  handler      = "index.handler"
  filename     = "${local.tags.Resource}-schedule.zip"

  memory_size = "128"

  layers = [aws_lambda_layer_version.lib.arn]

  timeout = 300 # 5min

  description = "Lambda function to revoke security group rule (media-platform only)"
}

resource "aws_cloudwatch_event_rule" "this" {
  name        = "${local.tags.Owner}-${local.tags.Resource}-lambda-schedule"
  description = "Revoke security group ingress"

  schedule_expression = "cron(0 0 * * ? *)" # utc 0:00 am = kst 9:00 am

}

resource "aws_cloudwatch_event_target" "this" {
  rule      = aws_cloudwatch_event_rule.this.name
  target_id = "lambda"
  arn       = aws_lambda_function.schedule.arn
}

resource "aws_lambda_permission" "this" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.schedule.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.this.arn
}

data "archive_file" "schedule" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/python/schedule"
  output_path = "${path.module}/${local.tags.Resource}-schedule.zip"
}
