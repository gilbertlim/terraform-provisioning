resource "aws_vpc_endpoint" "ssm" {
  vpc_id = var.vpc_id

  vpc_endpoint_type = "Interface"

  service_name = "com.amazonaws.ap-northeast-2.ssm"

  security_group_ids = [aws_security_group.this.id]
  subnet_ids         = [for subnet in var.private_subnets : subnet.id]

  tags = {
    Name = "vpce-${var.tags.Owner}-ec2-ssm"
  }

  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id = var.vpc_id

  vpc_endpoint_type = "Interface"

  service_name = "com.amazonaws.ap-northeast-2.ec2messages"

  security_group_ids = [aws_security_group.this.id]
  subnet_ids         = [for subnet in var.private_subnets : subnet.id]

  tags = {
    Name = "vpce-${var.tags.Owner}-ec2messages"
  }

  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id = var.vpc_id

  vpc_endpoint_type = "Interface"

  service_name = "com.amazonaws.ap-northeast-2.ssmmessages"

  security_group_ids = [aws_security_group.this.id]
  subnet_ids         = [for subnet in var.private_subnets : subnet.id]

  tags = {
    Name = "vpce-${var.tags.Owner}-ssmmessages"
  }

  private_dns_enabled = true
}

# interface형 Endpoint는 별도로 보안 그룹 필요
resource "aws_security_group" "this" {
  name   = "${var.tags.Owner}-interface-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.tags.Owner}-interface-sg"
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id = var.vpc_id

  service_name = "com.amazonaws.ap-northeast-2.s3"

  tags = {
    Name = "vpce-${var.tags.Owner}-s3"
  }

}

resource "aws_network_acl" "private" {
  vpc_id = var.vpc_id

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }


  tags = {
    Name = "acl-${var.tags.Owner}-private"
  }
}

resource "aws_network_acl_association" "private" {
  for_each       = var.private_subnets
  network_acl_id = aws_network_acl.private.id
  subnet_id      = each.value.id
}
