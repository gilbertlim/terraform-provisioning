resource "aws_iam_role" "this" {
  name = "${var.tags.Owner}-${var.tags.Resource}-${var.purpose}-role"

  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Sid    = ""
          Effect = "Allow"
          Principal = {
            Service = "lambda.amazonaws.com"
          }
          Action = "sts:AssumeRole"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "basic-execution-role" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
