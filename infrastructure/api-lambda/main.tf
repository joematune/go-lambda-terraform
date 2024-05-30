# ORIGINAL MODULE: https://github.com/terraform-aws-modules/terraform-aws-lambda/blob/master/main.tf

# THE MODULE DOESN'T CARE ABOUT THE PROVIDER? IT JUST EXPORTS HELPERS

# Random text for human-readable, random resource names
resource "random_pet" "lambda_bucket_name" {
  length = 3
}

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = random_pet.lambda_bucket_name.id
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "BucketOwnerPreferred"

  # TODO: What is the default value?
  versioning = {
    enabled = true
  }
}

module "lambda" {
  # The location of this module - will resolve to TF repository
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 3.0"

  function_name = var.function_name
  description   = "My awesome lambda function"
  runtime       = "provided.al2023"
  source_path = var.source_path
  handler       = "main"

  store_on_s3 = true
  s3_bucket = module.s3_bucket.s3_bucket_id

  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${module.api_gateway.apigatewayv2_api_execution_arn}/*/*"
    }
  }

  # Added to avoid error - Whether to publish creation/change as new Lambda Function Version.
  # https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/36#issuecomment-650217274
  publish = true
}

module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  name          = "serverless_lambda_gw"
  protocol_type = "HTTP"

  # Routes and integrations
  integrations = {
    "POST /hey" = {
      lambda_arn             = module.lambda.lambda_function_arn
      payload_format_version = "2.0"
      timeout_milliseconds   = 12000
    }
  }

  # No custom domain, please - default: true
  create_api_domain_name = false

  # CloudWatch Logs log group to receive access logs.
  default_stage_access_log_destination_arn = aws_cloudwatch_log_group.api_gw.arn
  default_stage_access_log_format = jsonencode({
    requestId               = "$context.requestId"
    sourceIp                = "$context.identity.sourceIp"
    requestTime             = "$context.requestTime"
    protocol                = "$context.protocol"
    httpMethod              = "$context.httpMethod"
    resourcePath            = "$context.resourcePath"
    routeKey                = "$context.routeKey"
    status                  = "$context.status"
    responseLength          = "$context.responseLength"
    integrationErrorMessage = "$context.integrationErrorMessage"
    }
  )
}

# Create API Gateway log group
resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw/${module.lambda.lambda_function_name}"

  retention_in_days = 30
}
