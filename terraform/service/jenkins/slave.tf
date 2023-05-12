resource "aws_instance" "slave" {
  instance_type = var.instance_type

  subnet_id = data.aws_subnet.private.id

  vpc_security_group_ids = [aws_security_group.this.id]

  ami = var.ami

  tags = {
    Name = "${local.tags.Owner}-${local.tags.Resource}-slave"
  }

  iam_instance_profile = data.aws_iam_instance_profile.this.name

  # user_data                   = data.template_file.jenkins_slave.rendered
  user_data_replace_on_change = false # when true, recreate instace
}

# data "template_file" "jenkins_slave" {
#   template = file(
#     "${path.module}/user_data/install-slave.sh"
#   )
# }
