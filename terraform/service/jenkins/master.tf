locals {
  tags = module.tags.tags
}

data "aws_iam_instance_profile" "this" {
  name = "${local.tags.Owner}-${local.tags.Resource}-profile"
}

data "aws_subnet" "private" {
  tags = {
    Name = "sbn-${local.tags.Owner}-pri-az2c"
  }
}

resource "aws_instance" "this" {
  instance_type = var.instance_type

  subnet_id = data.aws_subnet.private.id

  vpc_security_group_ids = [aws_security_group.this.id]

  ami = var.ami

  tags = {
    Name = "${local.tags.Owner}-${local.tags.Resource}"
  }

  iam_instance_profile = data.aws_iam_instance_profile.this.name

  # user_data                   = data.template_file.jenkins.rendered
  user_data                   = <<-EOF
Content-Type: multipart/mixed; boundary="//"
MIME-Version: 1.0

--//
Content-Type: text/cloud-config; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.txt"

#cloud-config
cloud_final_modules:
- [scripts-user, always]

--//
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="userdata.txt"

#!/bin/bash
sudo service jenkins start
--//--
  EOF
  user_data_replace_on_change = false # when true, recreate instace
}

# data "template_file" "jenkins" {
#   template = file(
#     "${path.module}/user_data/install-master.sh"
#   )
# }

resource "aws_security_group" "this" {
  name = "${local.tags.Owner}-${local.tags.Resource}-release-sg"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5299
    to_port     = 5299
    protocol    = "tcp"
    cidr_blocks = ["172.31.96.0/20"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.tags.Owner}-${local.tags.Resource}-release-sg"
  }
}
