data "aws_subnets" "public" {
  filter {
    name   = "tag:Name"
    values = ["sbn-${local.tags.Owner}-pub-az2b", "sbn-${local.tags.Owner}-pub-az2c"]
  }
}

resource "aws_lb" "this" {
  name               = "${local.tags.Owner}-${local.tags.Resource}-lb"
  load_balancer_type = "application"
  subnets            = [for subnet_id in data.aws_subnets.public.ids : subnet_id]
  security_groups    = [aws_security_group.alb.id]

  tags = {
    Name = "${module.tags.tags.Owner}-${module.tags.tags.Resource}-lb"
  }
}

resource "aws_security_group" "alb" {
  name = "${local.tags.Owner}-${local.tags.Resource}-lb-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["123.456.789.33/32", "123.456.789.34/32"]
    description = "building"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.tags.Owner}-${local.tags.Resource}-lb-sg"
  }
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = 404
    }
  }
}

resource "aws_lb_listener_rule" "this" {
  listener_arn = aws_lb_listener.this.arn

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  condition {
    http_header {
      http_header_name = "x-user-auth"
      values           = ["123456798ABCDEF"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_target_group" "this" {
  name = "${local.tags.Owner}-${local.tags.Resource}-tg"



  vpc_id   = var.vpc_id
  port     = 8080
  protocol = "HTTP"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "this" {
  target_group_arn = aws_lb_target_group.this.arn

  target_id = aws_instance.this.id

  port = 8080
}
