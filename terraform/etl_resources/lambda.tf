#lambda module    

module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"
#  version = "2.34.0"

  function_name = var.function_name
  description   = "My awesome lambda function"
  handler       = var.handler
  runtime       = var.runtime

  source_path = var.source_path

  tags = var.tags
  create_role = var.create_role
  lambda_role = "arn:aws:iam::298841451579:role/AWSPractice-Developer"
  create_package = false 
}

output "pwd" {
  value = "${path.module}"
}
