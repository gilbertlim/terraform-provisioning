terraform {
  backend "s3" {
    bucket  = "media-platform-terraform-state"
    key     = "terraform/service/ebs/terraform.tfstate"
    region  = "ap-northeast-2"
    encrypt = true
  }
}
