module "nginx" {
  source = "../_module/nginx"

  # for instance
  iam_instance_profile = data.aws_iam_instance_profile.this
  ami                  = var.ami
  instance_type        = var.instance_type
  subnet_id            = data.aws_subnet.private_a.id
  user_data            = <<-EOF
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
sudo su -
cd ~
service docker start
echo '${data.template_file.docker-compose-db.rendered}' > docker-compose.yml
docker-compose up
service httpd stop
nginx
--//--
EOF

  # for load balacncer
  vpc_id     = data.aws_vpc.ailab.id
  subnet_ids = data.aws_subnets.private.ids

  tags = module.tags.tags
}

data "template_file" "docker-compose-db" {
  template = file(
    "${path.module}/user_data/docker-compose.yml"
  )
}

data "aws_iam_instance_profile" "this" {
  name = "${module.tags.tags.Owner}-${module.tags.tags.Resource}-profile"
}

data "aws_subnet" "private_a" {
  tags = {
    Name = "sbn-${module.tags.tags.Owner}-pri-az2a"
  }
}

data "aws_vpc" "ailab" {
  id = "vpc-4e08f725"
}

data "aws_subnets" "private" {
  filter {
    name   = "tag:Name"
    values = ["sbn-${module.tags.tags.Owner}-pub-az2a", "sbn-${module.tags.tags.Owner}-pub-az2c"]
  }
}
