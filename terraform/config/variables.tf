
#Common 

variable "org" {}

variable "region" {}


### Tags 

variable "owner" {}

variable "stack_env" {}

variable "cost_center" {}

variable "application" {}


###S3 

variable "staging_bucket_name" {}

variable "landing_bucket_name" {}

variable "versioning" {}



### Glue variables 

variable "python_version" {}

variable "no_of_workers" {}

variable "script_location" {}



###Dynamodb 

variable "table_name" {}

variable "table_billing_mode" {}

variable "hash_key" {}

variable "range_key" {}

variable "rcu" {}

variable "wrc" {}

variable "dynamodb_table" {
    type = any
}


###Lambda

variable "function_name" {}

variable "handler" {}

variable "runtime" {}

variable "source_path" {}

variable "create_role" {}

variable "lambda_role" {}


#Cloudwatch Event 

variable "event_name" {}

variable "schedule_expression" {}

variable "target_id" {}


####Networking

variable "vpc_name" {}

variable "project" {}

variable "environment" {}

variable "cidr_block" {}

variable "public_subnet_cidr_blocks" {}

variable "private_subnet_cidr_blocks" {}

variable "availability_zones" {}
