#VPC
name = "test-terraform-vpc"
region = "us-east-1"
cidr_block = "10.0.0.0/16"
private_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.3.0/24"]
public_subnet_cidr_blocks = ["10.0.0.0/24", "10.0.2.0/24"]
availability_zones = ["us-east-1a", "us-east-1b"]

project = "Something"
environment = "Staging"


#module 
#s3 
#region = "us-east-1"
bucket_name = "test-terraform-s3-bucket345"
acl_value = "private"
versioning = true
tags = {
    Project        = "Talentnet"
    Environment = "Dev"
    }

#Dynamodb 
table_name         = "terraform-test-table"
table_billing_mode = "PROVISIONED"
hash_key           = "employee-id"



#glue 
python_version = "3"
no_of_workers = "2"
script_location = "s3://ateststack-mycdkrallybucket34563723813c-9yh1y22c9zhe/test_job.py"

