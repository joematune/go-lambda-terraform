# Original module: https://github.com/terraform-aws-modules/terraform-aws-lambda/blob/master/main.tf

# The module doesn't care about the provider, it just exports helpers

module "lambda" {
  # The location of this module - will resolve to TF repository
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 7.4"

  function_name = var.function_name
  description   = "My awesome SQS lambda function"
  runtime       = "provided.al2023"
  source_path   = var.source_path
  handler       = "main"

  store_on_s3 = true
  s3_bucket   = var.s3_bucket_id

  attach_cloudwatch_logs_policy = true

  # TODO: Seems like overkill, do we need this?
  create_current_version_allowed_triggers = false
  # TODO: Do we need this if we're not doing any vpc/network stuff?
  attach_network_policy = true

  attach_policy_statements = true
  policy_statements = {
    # Allow failures to be sent to SQS queue
    sqs_dead_letter = {
      effect    = "Allow",
      actions   = ["sqs:SendMessage"],
      resources = [aws_sqs_queue.dlq.arn]
    }
  }

  event_source_mapping = {
    sqs = {
      event_source_arn        = aws_sqs_queue.this.arn
      function_response_types = ["ReportBatchItemFailures"]
      scaling_config = {
        maximum_concurrency = 20
      }
    }
  }
  allowed_triggers = {
    sqs = {
      principal  = "sqs.amazonaws.com"
      source_arn = aws_sqs_queue.this.arn
    }
  }
  attach_policies    = true
  number_of_policies = 3
  policies = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole",
    "arn:aws:iam::aws:policy/service-role/AWSLambdaDynamoDBExecutionRole",
    "arn:aws:iam::aws:policy/service-role/AWSLambdaKinesisExecutionRole",
  ]

  # Added to avoid error - Whether to publish creation/change as new Lambda Function Version.
  # https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/36#issuecomment-650217274
  publish = true
}

# SQS
resource "aws_sqs_queue" "this" {
  name = var.queue_name
}

resource "aws_sqs_queue" "dlq" {
  name = "${var.queue_name}-dlq"
}
