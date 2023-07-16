provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      joe-learns = "terraform-modules"
    }
  }

}

resource "random_pet" "lambda_bucket_name" {
  prefix = "learn-terraform-modules"
  length = 4
}

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

data "archive_file" "lambda_hey_joe" {
  type = "zip"

  # Our build binary output
  source_file  = "${path.module}/main"
  output_path = "${path.module}/hey-joe.zip"
}

resource "aws_s3_object" "lambda_hey_joe" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "hey-joe.zip"
  source = data.archive_file.lambda_hey_joe.output_path

  etag = filemd5(data.archive_file.lambda_hey_joe.output_path)
}

resource "aws_lambda_function" "hey_joe" {
  runtime = "go1.x"
  function_name = "HeyJoe"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_hey_joe.key

  # https://docs.aws.amazon.com/lambda/latest/dg/golang-handler.html
  # Maybe this references the binary? Or the function?
  # See `handler` here: https://registry.terraform.io/modules/terraform-aws-modules/lambda/aws/latest?tab=inputs
  handler = "main"
  # In interpreted, we point to the file, then function: handler = "hey.handler"

  source_code_hash = data.archive_file.lambda_hey_joe.output_base64sha256
  role = aws_iam_role.lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "hey_joe" {
  name = "/aws/lambda/${aws_lambda_function.hey_joe.function_name}"

  retention_in_days = 30
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  # As name implies, basic execution allowances provided as a convenience
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_apigatewayv2_api" "lambda" {
  name          = "serverless_lambda_gw"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "lambda" {
  api_id = aws_apigatewayv2_api.lambda.id

  name        = "serverless_lambda_stage"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn

    format = jsonencode({
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
}

resource "aws_apigatewayv2_integration" "hey_joe" {
  api_id = aws_apigatewayv2_api.lambda.id

  integration_uri    = aws_lambda_function.hey_joe.invoke_arn
  integration_type   = "AWS_PROXY"
  # This does not seem to affect the aws_apigatewayv2_route resource. The route can be GET and works perfectly
  # https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-apigatewayv2-integration.html#cfn-apigatewayv2-integration-integrationmethod
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "hey_joe" {
  api_id = aws_apigatewayv2_api.lambda.id

  route_key = "POST /hey"
  target    = "integrations/${aws_apigatewayv2_integration.hey_joe.id}"
}

resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.lambda.name}"

  retention_in_days = 30
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hey_joe.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}
