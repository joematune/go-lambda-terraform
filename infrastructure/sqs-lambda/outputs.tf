# Output values, i.e. resource properties

output "function_name" {
  description = "Name of the Lambda function."

  value = module.lambda.lambda_function_name
}

output "queue_url" {
  description = "Queue URL that Lambda consumes"

  value = aws_sqs_queue.this.url
}

output "log_group_name" {
  description = "Log group name for inspection / tailing."
  value       = module.lambda.lambda_cloudwatch_log_group_name
}
