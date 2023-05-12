locals {
  tags = {
    Owner    = var.profile
    Resource = var.resource
    Purpose  = var.purpose
  }
}
