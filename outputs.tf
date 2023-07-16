# Output values, i.e. resource properties

output "lambda_bucket_name" {
  description = "Name of the S3 bucket used to store function code."

  value = aws_s3_bucket.lambda_bucket.id
}

output "function_name" {
  description = "Name of the Lambda function."

  value = aws_lambda_function.hey_joe.function_name
}

output "base_url" {
  description = "Base URL for API Gateway stage."

  value = aws_apigatewayv2_stage.lambda.invoke_url
}

output "log_group_name" {
  description = "Log group name for inspection / tailing."

  value = aws_cloudwatch_log_group.hey_joe.name
}
