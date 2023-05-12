terraform {
  backend "s3" {
    bucket  = "media-platform-terraform-state"
    key     = "terraform/vpc/media-platform-vpc/terraform.tfstate"
    region  = "ap-northeast-2"
    encrypt = true
  }
}
