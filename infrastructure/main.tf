## DUMMY LAMBDA FUNCTION 
resource "aws_lambda_function" "this" {
  filename         = var.function_filename
  function_name    = var.function_name
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = var.function_handler
  runtime          = var.function_runtime
  source_code_hash = filebase64sha256(var.function_filename)

  environment {
    variables = {
      S3_BUCKET  = var.s3_bucket_name
      OBJECT_KEY = var.db_pass_file_name
      KEY_ALIAS  = var.kms_alias
      SECRET_ARN = aws_secretsmanager_secret.this.arn
    }
  }
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.this.arn
}


# S3 BUCKET
# s3 bucket to store the secret and trigger the lambda by an event 

resource "aws_s3_bucket" "this" {
  bucket = var.s3_bucket_name
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.this.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.this.arn
    events              = ["s3:ObjectCreated:Put"]
    filter_suffix       = var.db_pass_file_name
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}

## SECRET MANAGER   

resource "aws_secretsmanager_secret" "this" {
  name = var.secret_name
}

#KMS KEY

resource "aws_kms_key" "this" {}

resource "aws_kms_alias" "this" {
  name          = var.kms_alias
  target_key_id = aws_kms_key.this.key_id
}