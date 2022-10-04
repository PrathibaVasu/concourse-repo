
resource "aws_glue_job" "rds_glue_job" {
  name     = local.rds_glue_name
  role_arn = "arn:aws:iam::298841451579:role/AWSPractice-Developer"
  glue_version = "3.0"

  command {
    script_location = "s3://ateststack-mycdkrallybucket34563723813c-9yh1y22c9zhe/test_job.py"
    name            = "pythonshell"
    python_version  = var.python_version
  }
  execution_property {
    max_concurrent_runs = 2
  }
  default_arguments = {
    # ... potentially other arguments ...
    #"--continuous-log-logGroup"          = aws_cloudwatch_log_group.example.name
    #"--enable-continuous-cloudwatch-log" = "true"
    #"--enable-continuous-log-filter"     = "true"
    #"--enable-metrics"                   = ""
  }  
  tags = local.tags 
}

resource "aws_glue_job" "mongodb_glue_job" {
  name     = local.mongodb_glue_name
  role_arn = "arn:aws:iam::298841451579:role/AWSPractice-Developer"
  glue_version = "3.0"

  command {
    script_location = "s3://ateststack-mycdkrallybucket34563723813c-9yh1y22c9zhe/test_job.py"
    name            = "pythonshell"
    python_version  = var.python_version
  }
  execution_property {
    max_concurrent_runs = 2
  }
  default_arguments = {
    # ... potentially other arguments ...
    #"--continuous-log-logGroup"          = aws_cloudwatch_log_group.example.name
    #"--enable-continuous-cloudwatch-log" = "true"
    #"--enable-continuous-log-filter"     = "true"
    #"--enable-metrics"                   = ""
  }  
  tags = local.tags 
}



# Glue job for integration 
resource "aws_glue_job" "glue_job" {
  name     = "terraform_example_job"
  role_arn = "arn:aws:iam::298841451579:role/AWSPractice-Developer"
  glue_version = "3.0"

  command {
    script_location = "s3://ateststack-mycdkrallybucket34563723813c-9yh1y22c9zhe/test_job.py"
    name            = "glueetl"
    python_version  = var.python_version
  }

  worker_type = "G.1X"
  number_of_workers = var.no_of_workers

  default_arguments = {
    # ... potentially other arguments ...
    #"--continuous-log-logGroup"          = aws_cloudwatch_log_group.example.name
    #"--enable-continuous-cloudwatch-log" = "true"
    #"--enable-continuous-log-filter"     = "true"
    #"--enable-metrics"                   = ""
  }  
  tags = local.tags 
}