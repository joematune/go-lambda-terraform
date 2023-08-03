# Output values, i.e. resource properties

output "lambda_bucket_name" {
  description = "Name of the S3 bucket used to store function code."

  value = module.s3_bucket.s3_bucket_id
}

output "function_name" {
  description = "Name of the Lambda function."

  value = module.lambda_function.lambda_function_name
}

output "base_url" {
  description = "Base URL for API Gateway stage."

  value = module.api_gateway.default_apigatewayv2_stage_invoke_url
}
