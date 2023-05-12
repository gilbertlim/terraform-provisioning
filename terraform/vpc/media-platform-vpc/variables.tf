variable "vpc_id" {
  default = "vpc-4e08f725"
}

variable "private_subnets" {
  default = {
    "2a" = {
      cidr_block        = "172.31.64.0/20",
      availability_zone = "ap-northeast-2a"
    },
    "2b" = {
      cidr_block        = "172.31.80.0/20",
      availability_zone = "ap-northeast-2b"
    },
    "2c" = {
      cidr_block        = "172.31.96.0/20",
      availability_zone = "ap-northeast-2c"
    },
    "2d" = {
      cidr_block        = "172.31.112.0/20",
      availability_zone = "ap-northeast-2d"
    }
  }
}
