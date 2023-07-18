provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      joe-learns = "terraform-modules"
    }
  }
}

# Random text for human-readable, random resource names
resource "random_pet" "lambda_bucket_name" {
  prefix = "learn-terraform-modules"
  length = 4
}

# S3 Bucket creation - this example requires zero pre-existing resources

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = random_pet.lambda_bucket_name.id
}

resource "aws_s3_bucket_ownership_controls" "lambda_bucket" {
  bucket = aws_s3_bucket.lambda_bucket.id
  # The default rule changed for aws and terraform doesn't default correctly?
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.lambda_bucket]

  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}

module "lambda_function" {
  # The location of this module - will resolve to TF repository
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 3.0"

  function_name = "HeyJoe"
  description   = "My awesome lambda function"
  handler       = "main"
  runtime       = "go1.x"

  source_path = "${path.module}/main"

  store_on_s3 = true
  s3_bucket = aws_s3_bucket.lambda_bucket.id

  # Added to avoid error
  # https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/36#issuecomment-650217274
  publish = true
  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${module.api_gateway.apigatewayv2_api_execution_arn}/*/*"
    }
  }
}

module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  name          = "serverless_lambda_gw"
  protocol_type = "HTTP"

  cors_configuration = {
    allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }

  # No custom domain, please
  create_api_domain_name = false

  # Access logs
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

  # Routes and integrations
  integrations = {
    "POST /hey" = {
      lambda_arn             = module.lambda_function.lambda_function_arn
      payload_format_version = "2.0"
      timeout_milliseconds   = 12000
    }
  }
}

# Create API Gateway log group
resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw/${module.lambda_function.lambda_function_name}"

  retention_in_days = 30
}
