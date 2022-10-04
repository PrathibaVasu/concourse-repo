###rds event 

resource "aws_cloudwatch_event_rule" "rds_event" {
  name                = local.event_name
  description         = "Fires every five minutes"
  schedule_expression = var.schedule_expression
  tags                = local.tags 
}

resource "aws_cloudwatch_event_target" "rds_lambda_target" {
  rule      = aws_cloudwatch_event_rule.rds_event.name
  target_id = local.rds_lambda_target
  arn       = module.rds_lambda_function.lambda_function_arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_rds_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = module.rds_lambda_function.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.rds_event.arn
}


###mongodb event 

resource "aws_cloudwatch_event_rule" "mongodb_event" {
  name                = local.event_name
  description         = "Fires every five minutes"
  schedule_expression = var.schedule_expression
  tags                = local.tags 
}

resource "aws_cloudwatch_event_target" "mongodb_lambda_target" {
  rule      = aws_cloudwatch_event_rule.mongodb_event.name
  target_id = local.mongodb_lambda_target
  arn       = module.mongodb_lambda_function.lambda_function_arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_mongodb_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = module.mongodb_lambda_function.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.mongodb_event.arn
}
