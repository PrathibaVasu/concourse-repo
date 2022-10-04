#Common 
org = "TalentNet"
region = "us-east-1"

# Tags  
owner = "xxx@talentnet.com"  
stack_env = "dev" 
cost_center = "38858" 
application = "edw"

#S3
staging_bucket_name = "test-terraform-bucket1234"
landing_bucket_name = "test2-terraform-bucket1234"

versioning = {
    status     = true
  }


#Dynamodb 
table_name     = "terraform-test-table"
hash_key    = "id"
range_key   = "title"
table_billing_mode = "PROVISIONED"
rcu = 10 
wrc = 10


dynamodb_table = {
    table1 = {
      name = "test-table1"
      hash_key = "id"
      hask_key_type = "N"
      range_key = "name"
      range_key_type = "S"
      }

    table2 = {
      hash_key = "id"
      hask_key_type = "N"
      range_key = "name"
      range_key_type = "S"
    }
    table3 = {
      hash_key = "id"
      hask_key_type = "N"
      range_key = "name"
      range_key_type = "S"
    }
  }
}



#Glue 
python_version  =  "3"
no_of_workers = "2"
script_location = "s3://ateststack-mycdkrallybucket34563723813c-9yh1y22c9zhe/test_job.py"

#Lambda 
function_name = "terraform-test-function"
handler       = "index.lambda_handler"
runtime       = "python3.9"  
source_path = "${path.module}/terraform/scripts/lambda_scripts/rds_lambda_handler"
create_role = false
lambda_role = "arn:aws:iam::298841451579:role/AWSPractice-Developer"

#Event 
event_name                = "terraform-test-event"
schedule_expression = "rate(10 minutes)" #"cron(0 20 * * ? *)"
target_id  = "test-terraform-rule"


#VPC 
vpc_name = "test-terraform-vpc"
cidr_block = "10.0.0.0/16"
private_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.3.0/24"]
public_subnet_cidr_blocks = ["10.0.0.0/24", "10.0.2.0/24"]
availability_zones = ["us-east-1a", "us-east-1b"]

project = "Something"
environment = "Staging"

