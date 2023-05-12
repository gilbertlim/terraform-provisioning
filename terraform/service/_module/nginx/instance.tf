resource "aws_instance" "this" {
  instance_type = var.instance_type

  subnet_id = var.subnet_id

  vpc_security_group_ids = [aws_security_group.this.id]

  ami = var.ami

  tags = {
    Name = "${var.tags.Owner}-${var.tags.Resource}"
  }

  iam_instance_profile = var.iam_instance_profile.name

  # user_data                   = data.template_file.webserver.rendered
  user_data                   = var.user_data
  user_data_replace_on_change = false # when true, recreate instace
}

# data "template_file" "webserver" {
#   template = file(
#     "${path.module}/user_data/webserver.sh"
#   )
# }

resource "aws_security_group" "this" {
  name = "${var.tags.Owner}-${var.tags.Resource}-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/20"]
    description = "alb(public a) to api"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["172.31.32.0/20"]
    description = "alb(public c) to api"
  }

  # for tunneling
  ingress {
    from_port   = 5299
    to_port     = 5299
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/20"]
    description = "bastion(public a) to ssh"
  }
  # ingress {
  #   from_port   = -1
  #   to_port     = -1
  #   protocol    = "icmp"
  #   cidr_blocks = ["172.31.0.0/20"]
  #   description = "bastion(public a) - ping"
  # }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/20"]
    description = "bastion(public a) to mariadb"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "nat gateway"
  }

  tags = {
    Name = "${var.tags.Owner}-${var.tags.Resource}-sg"
  }
}
