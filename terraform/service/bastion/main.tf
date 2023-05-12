locals {
  tags = module.tags.tags
}

data "aws_iam_instance_profile" "this" {
  name = "${local.tags.Owner}-${local.tags.Resource}-profile"
}

data "aws_subnet" "private" {
  tags = {
    Name = "sbn-${local.tags.Owner}-pub-az2a"
  }
}

resource "aws_instance" "this" {
  instance_type = var.instance_type

  subnet_id = data.aws_subnet.private.id

  vpc_security_group_ids = [aws_security_group.this.id]

  iam_instance_profile = data.aws_iam_instance_profile.this.name

  associate_public_ip_address = true

  key_name = aws_key_pair.this.key_name

  ami = var.ami

  tags = {
    Name = "${local.tags.Owner}-${local.tags.Resource}"
  }
}

resource "aws_key_pair" "this" {
  key_name   = "${local.tags.Owner}-${local.tags.Resource}-key"
  public_key = tls_private_key.this.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.this.private_key_pem}' > /Users/mz01-lsjin/study/nginx/media-platform-bastion-key.pem"
  }

  tags = {
    description = "terraform key pair import"
  }
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_security_group" "this" {
  name = "${local.tags.Owner}-${local.tags.Resource}-sg"

  ingress {
    # sudo vi /etc/ssh/sshd_config Port 5299
    # sudo service sshd restart
    from_port   = 5299
    to_port     = 5299
    protocol    = "tcp"
    cidr_blocks = ["121.134.158.33/32", "121.134.158.34/32"]
    description = "geumjung building"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.tags.Owner}-${local.tags.Resource}-sg"
  }
}

resource "aws_eip" "this" {
  instance = aws_instance.this.id
  vpc      = true

  tags = {
    Name = "${local.tags.Owner}-${local.tags.Resource}-eip"
  }
}
