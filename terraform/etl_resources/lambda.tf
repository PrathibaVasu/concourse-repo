#rds lambda function    

module "rds_lambda_function" {
  source = "terraform-aws-modules/lambda/aws"
#  version = "2.34.0"

  function_name = local.rds_function_name
  description   = "My awesome lambda function"
  handler       = var.handler
  runtime       = var.runtime
  source_path = var.source_path
  environment_variables = {
    "GLUE_ARN" = aws_glue_job.rds_glue_job.arn
  }
  create_role = var.create_role
  lambda_role = var.lambda_role 
  create_package = false 
  tags = local.tags
}

#mongodb lambda function   
module "mongodb_lambda_function" {
  source = "terraform-aws-modules/lambda/aws"
#  version = "2.34.0"

  function_name = local.mongodb_function_name
  description   = "My awesome lambda function"
  handler       = var.handler
  runtime       = var.runtime
  source_path = var.source_path
  environment_variables = {
    "GLUE_ARN" = aws_glue_job.mongodb_glue_job.arn
  }
  create_role = var.create_role
  lambda_role = var.lambda_role 
  create_package = false 
  tags = local.tags
}

output "pwd" {
  value = "${path.module}"
}
