variable "profile" {
  default = "media-platform"
}

variable "resource" {
  description = "nginx, s3, ..."
  default     = ""
}

variable "purpose" {
  description = "logs, ..."
  default     = ""
}
