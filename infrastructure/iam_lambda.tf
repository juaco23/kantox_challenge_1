#LAMBDA IAM ROLE
resource "aws_iam_role" "iam_for_lambda" {
  name = "${var.function_name}_iam_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# LAMBDA POLICY DOCUMENT

data "aws_iam_policy_document" "this" {
  statement {
    sid    = "BucketPermissions"
    effect = "Allow"
    actions = [
      "s3:GetObjectAcl",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:GetObjectVersion",
    ]

    resources = [
      "${aws_s3_bucket.this.arn}/${var.db_pass_file_name}",
      "${aws_s3_bucket.this.arn}"
    ]
  }
  statement {
    sid    = "SecretManagerPermissions"
    effect = "Allow"

    actions = [
      "secretsmanager:PutSecretValue",
      "secretsmanager:UpdateSecret"
    ]

    resources = [
      "${aws_secretsmanager_secret.this.arn}",

    ]
  }
  statement {
    sid    = "KMSPermissions"
    effect = "Allow"

    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
    ]

    resources = [
      "${aws_kms_key.this.arn}",

    ]
  }
}
# LAMBDA POLICY
resource "aws_iam_policy" "this" {
  name   = "${var.function_name}_iam_policy"
  path   = "/"
  policy = data.aws_iam_policy_document.this.json
}

# LAMBDA POLICY ROLE ATTACHMENT

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.this.arn
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "${var.function_name}_iam_policy_coudwatch_logs"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}