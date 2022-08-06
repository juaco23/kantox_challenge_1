output "lambda_arn" {
  value       = aws_lambda_function.this.arn
  description = "The Lambda function ARN"
}

output "bucket_name" {
  value       = aws_s3_bucket.this.bucket
  description = "The name of the bucket where the secret file will be store"
}

output "githu_role_arn" {
  value       = aws_iam_role.github_actions.arn
  description = "The GitHub Role ARN"
}
