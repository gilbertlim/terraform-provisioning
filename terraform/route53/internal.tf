resource "aws_route53_zone" "internal" {
  name = "media-platform.internal"

  tags = {
    Name = "media-platform.internal"
  }
  vpc {
    vpc_id = data.aws_vpc.this.id
  }
}

resource "aws_route53_record" "nginx-internal" {
  zone_id = aws_route53_zone.internal.id
  name    = "nginx.media-platform.internal"
  type    = "A"
  ttl     = "300"
  records = [data.aws_instance.nginx.private_ip]
}

data "aws_instance" "nginx" {
  filter {
    name   = "tag:Name"
    values = ["media-platform-nginx"]
  }
}

data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = ["media-platform-vpc"]
  }
}
