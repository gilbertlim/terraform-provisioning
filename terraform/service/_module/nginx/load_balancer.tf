resource "aws_lb" "this" {
  name               = "${var.tags.Owner}-${var.tags.Resource}-lb"
  load_balancer_type = "application"
  subnets            = [for subnet_id in var.subnet_ids : subnet_id]
  security_groups    = [aws_security_group.alb.id]

  tags = {
    Name = "${var.tags.Owner}-${var.tags.Resource}-lb"
  }
}

resource "aws_security_group" "alb" {
  name = "${var.tags.Owner}-${var.tags.Resource}-alb-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.tags.Owner}-${var.tags.Resource}-alb-sg"
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
  name = "${var.tags.Owner}-${var.tags.Resource}-tg"

  vpc_id   = var.vpc_id
  port     = 80
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
  target_id        = aws_instance.this.id
  port             = 80
}
