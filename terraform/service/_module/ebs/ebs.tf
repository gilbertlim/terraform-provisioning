resource "aws_ebs_volume" "this" {
  availability_zone = var.availability_zone
  size              = var.size
  type              = var.type

  tags = {
    Name = "${var.tags.Owner}-${var.tags.Resource}"
  }
}

resource "aws_volume_attachment" "nginx" {
  device_name = "/dev/sdf"
  instance_id = var.instance_id
  volume_id   = aws_ebs_volume.this.id
}
