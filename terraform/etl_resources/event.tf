
/*
###couldwatch event 

resource "aws_cloudwatch_event_rule" "every_five_minutes" {
  name                = var.event_name
  description         = "Fires every five minutes"
  schedule_expression = var.schedule_expression
}

resource "aws_cloudwatch_event_target" "check_foo_every_five_minutes" {
  rule      = aws_cloudwatch_event_rule.every_five_minutes.name
  target_id = var.target_id
  arn       = module.lambda_function.lambda_function_arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_check_foo" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_function.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_five_minutes.arn
}

*/