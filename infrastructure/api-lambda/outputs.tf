# Output values, i.e. resource properties

output "function_name" {
  description = "Name of the Lambda function."

  value = module.lambda.lambda_function_name
}

output "base_url" {
  description = "Base URL for API Gateway stage."

  value = module.api_gateway.default_apigatewayv2_stage_invoke_url
}

output "log_group_name" {
  description = "Log group name for inspection / tailing."
  value       = module.lambda.lambda_cloudwatch_log_group_name
}
