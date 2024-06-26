# # Output values, i.e. resource properties

output "lambda_bucket_name" {
  description = "Name of the S3 bucket used to store function code."

  value = module.lambda_s3_bucket.s3_bucket_id
}

output "api_function_name" {
  description = "Name of the Lambda function."

  value = module.api_lambda.function_name
}

output "base_url" {
  description = "Base URL for API Gateway stage."

  value = module.api_lambda.base_url
}

output "api_log_group_name" {
  description = "Log group name for inspection / tailing."

  value = module.api_lambda.log_group_name
}

output "queue_url" {
  description = "Queue URL that Lambda consumes."

  value = module.sqs_lambda.queue_url
}

output "sqs_log_group_name" {
  description = "Log group name for inspection / tailing."

  value = module.sqs_lambda.log_group_name
}
