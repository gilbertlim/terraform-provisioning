module "main" {
  source = "../_module/lambda"

  tags    = local.tags
  purpose = "main"
}

resource "aws_iam_role_policy" "ec2_sg" {
  name = "${local.tags.Owner}-${local.tags.Resource}-update-security-group-policy"

  role = module.main.role_name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:RevokeSecurityGroupIngress"
      ],
      "Resource": ["${data.aws_security_group.bastion.arn}",
                   "${data.aws_security_group.jenkins.arn}"]
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeSecurityGroups"
      ],
      "Resource": "*"
    }
  ]
}

EOF
}

data "aws_security_group" "bastion" {
  filter {
    name   = "tag:Name"
    values = ["${local.tags.Owner}-bastion-sg"]
  }
}

data "aws_security_group" "jenkins" {
  filter {
    name   = "tag:Name"
    values = ["${local.tags.Owner}-jenkins-lb-sg"]
  }
}
