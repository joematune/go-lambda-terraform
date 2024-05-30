provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      joe-does = "terraform-modules"
    }
  }
}

module "lambda_s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = var.service
  acl    = "private"
  control_object_ownership = true
  object_ownership         = "BucketOwnerPreferred"
}

module "api_lambda" {
  source = "./api-lambda"

  function_name = var.service
  source_path = "${path.module}/../bootstrap"
  s3_bucket_id = module.lambda_s3_bucket.s3_bucket_id
}
