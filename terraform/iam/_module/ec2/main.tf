resource "aws_iam_role" "this" {
  name = "${var.tags.Owner}-${var.tags.Resource}-role"

  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Sid    = ""
          Effect = "Allow"
          Action = "sts:AssumeRole"
          Principal = {
            Service = "ec2.amazonaws.com"
          }
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "core" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.tags.Owner}-${var.tags.Resource}-profile"
  role = aws_iam_role.this.name
  path = "/"
}
