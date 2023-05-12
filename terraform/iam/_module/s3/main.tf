resource "aws_iam_role_policy" "s3_access" {
  name = "policy-${var.tags.Owner}-${var.tags.Resource}-s3-access"

  role = var.role

  policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Sid    = "",
          Effect = "Allow",
          Action = [
            "s3:ListBucket",
            "s3:*Object"
          ],
          Resource = var.bucket
        }
      ]
    }
  )
}
