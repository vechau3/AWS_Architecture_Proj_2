provider "aws" {
  access_key = "AKIA5WFHDELO6YPLALUA"
  secret_key = "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"
  region = var.aws_region
}

resource "aws_instance" "UdacityT2" {
  ami = "ami-0b5eea76982371e91"
  instance_type = "t2.micro"
  count = "4"
  tags = {
    Name = "Udacity instance micro"
  }
}

resource "aws_iam_role" "function_role" {
  name = "function_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

# Lambda function
resource "aws_lambda_function" "greet_lambda_func" {
  filename      = "greet_lambda.zip"
  function_name = "greet_lambda"
  role          = aws_iam_role.function_role.arn
  handler       = "greet_lambda.lambda_handler"

  source_code_hash = filebase64sha256("greet_lambda.zip")

  runtime = "python3.7"

  environment {
    variables = {
      greeting = "Udacity, Hello World!!!!!"
    }
  }
}

# Cloudwatch logging
resource "aws_cloudwatch_log_group" "greet_lambda_cloudwatch_log_group" {
  name = "/aws/lambda/${aws_lambda_function.greet_lambda_func.function_name}"
  retention_in_days = 7
}

# IAM policy
resource "aws_iam_policy" "logging_policy" {
  name        = "logging_policy"
  path        = "/"
  description = "Pplicy logging"

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

resource "aws_iam_role_policy_attachment" "logging_iam_policy_attachment" {
  role       = aws_iam_role.function_role.name
  policy_arn = aws_iam_policy.logging_policy.arn
}