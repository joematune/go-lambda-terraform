provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      joe-does = "terraform-modules"
    }
  }
}

module "api_lambda" {
  source = "./api-lambda"

  function_name = "HeyJoe"
  source_path = "${path.module}/../bootstrap"
}
