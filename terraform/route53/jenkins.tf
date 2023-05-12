resource "aws_route53_record" "jenkins" {
  zone_id = var.route53_hosted_zone_id
  name    = "rel-1team.gilbert.com"
  type    = "A"

  alias {
    name                   = data.aws_lb.jenkins.dns_name
    zone_id                = data.aws_lb.jenkins.zone_id
    evaluate_target_health = true
  }
}

data "aws_lb" "jenkins" {
  tags = {
    Name = "media-platform-jenkins-lb"
  }
}
