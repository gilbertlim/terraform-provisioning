resource "aws_route53_record" "nginx" {
  zone_id = var.route53_hosted_zone_id
  name    = "dev-1team.gilbert.com"
  type    = "A"

  alias {
    name                   = data.aws_lb.nginx.dns_name
    zone_id                = data.aws_lb.nginx.zone_id
    evaluate_target_health = true
  }
}

data "aws_lb" "nginx" {
  tags = {
    Name = "media-platform-nginx-lb"
  }
}
