output "s3_bucket_name" {
  value       = aws_s3_bucket.terraform_state.arn
  description = "The ARN of the s3 bucket"
}
