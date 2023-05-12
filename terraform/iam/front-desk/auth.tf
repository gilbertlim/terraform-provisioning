module "auth" {
  source = "../_module/lambda"

  tags    = local.tags
  purpose = "auth"
}

resource "aws_iam_role_policy" "lambda_invoke" {
  name = "${local.tags.Owner}-${local.tags.Resource}-auth-lambda-policy"

  role = module.auth.role_name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "lambda:InvokeFunction"
      ],
      "Resource": "${data.aws_lambda_function.main.arn}"
    }
  ]
}

EOF
}

data "aws_lambda_function" "main" {
  function_name = "${local.tags.Owner}-${local.tags.Resource}-main-fn"
}
