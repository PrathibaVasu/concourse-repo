#lambda module    

module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"
#  version = "2.34.0"

  function_name = "terraform-test-function"
  description   = "My awesome lambda function"
  handler       = "index.lambda_handler"
  runtime       = "python3.9"

  source_path = "${path.module}/../scripts/lambda_scripts/rds_lambda_handler/"
  #source_path = "terraform-resources/terraform/scripts/lambda_scripts/rds_lambda_handler"

  tags = {
    Name = "my-lambda1"
  }
  create_role = false
  lambda_role = "arn:aws:iam::298841451579:role/AWSPractice-Developer"
}

