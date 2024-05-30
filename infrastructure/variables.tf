# Input variable definitions

variable "service" {
  description = "The name of this application"
  type = string
  default = "hey-joe"
}

variable "aws_region" {
  description = "AWS region for all resources."

  type    = string
  default = "us-east-1"
}
