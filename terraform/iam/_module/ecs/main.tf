resource "aws_iam_role_policy" "ecs" {
  name = "${var.tags.Owner}-${var.tags.Resource}-ecs-deploy-policy"

  role = var.ec2_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "ecs:RegisterTaskDefinition",
        "ecs:ListClusters",
        "ecs:DescribeContainerInstances",
        "ecs:ListTaskDefinitions",
        "ecs:DescribeTaskDefinition",
        "ecs:DeregisterTaskDefinition"
      ],
      "Resource": "*"
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "ecs:ListContainerInstances",
        "ecs:DescribeClusters"
      ],
      "Resource": "${data.aws_ecs_cluster.this.arn}"
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "ecs:RunTask"
      ],
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${data.aws_ecs_cluster.this.arn}"
        }
      },
      "Resource": "${replace(split("/", data.aws_ecs_cluster.this.arn)[0], "cluster", "task-definition/*")}"
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "ecs:StopTask"
      ],
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${data.aws_ecs_cluster.this.arn}"
        }
      },
      "Resource": "arn:aws:ecs:*:*:task/*"
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "ecs:DescribeTasks"
      ],
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${data.aws_ecs_cluster.this.arn}"
        }
      },
      "Resource":  "arn:aws:ecs:*:*:task/*"
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "elasticfilesystem:DescribeAccessPoints",
        "elasticfilesystem:DescribeFileSystems"
      ],
      "Resource": "${replace(replace(split("/", data.aws_ecs_cluster.this.arn)[0], "cluster", "file-system/*"), "ecs", "elasticfilesystem")}"
    }
  ]
}

EOF
}

data "aws_ecs_cluster" "this" {
  cluster_name = "${var.tags.Owner}-${var.tags.Resource}-cluster"
}
