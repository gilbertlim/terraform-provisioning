terraform {
  backend "s3" {
    bucket  = "media-platform-terraform-state"
    key     = "terraform/s3/share/nginx/terraform.tfstate"
    region  = "ap-northeast-2"
    encrypt = true
  }
}
