resource "aws_route53_record" "bastion" {
  zone_id = var.route53_hosted_zone_id
  name    = "bastion-1team.gilbert.com"
  type    = "A"
  ttl     = 300
  records = ["${data.aws_eip.this.public_ip}"]
}

data "aws_eip" "this" {
  filter {
    name   = "tag:Name"
    values = ["media-platform-bastion-eip"]
  }
}
