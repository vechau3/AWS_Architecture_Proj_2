# TODO: Define the output variable for the lambda function.
output "lambda_greeting" {
  value = aws_lambda_function.greet_lambda_func.environment[0].variables["greeting"]
}