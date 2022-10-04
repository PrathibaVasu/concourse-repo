locals  {
    tags = {
        "tn:owner" = var.owner  
        "tn:stack-env" = var.stack_env 
        "tn:costcenter" = var.cost_center
        "tn:application" = var.application
        }  

    #S3
    s3_bucket_name = [var.staging_bucket_name, var.landing_bucket_name]
    staging_bucket_name = "${var.org}-${var.region}-${var.stack_env}-s3-staging-bucket" 
    integration_bucket_name = "${var.org}-${var.region}-${var.stack_env}-s3-integration-bucket" 

    #Dynamodb 
    dynamodb_table = var.dynamodb_table

    #Event 
    rds_event_name = "${var.org}-${var.region}-${var.stack_env}-event-rds" 
    mongodb_event_name = "${var.org}-${var.region}-${var.stack_env}-event-mongodb" 
    rds_target_id  = "rds-lambda-target"
    mongodb_target_id =  "mongodb-lambda-target"

    #Lambda 
    rds_function_name = "${var.org}-${var.region}-${var.stack_env}-lambda-rds-function" 
    mongodb_function_name = "${var.org}-${var.region}-${var.stack_env}-lambda-mongodb-function" 

    #Glue job 
    rds_glue_name = "${var.org}-${var.region}-${var.stack_env}-glue-job-rds"
    mongodb_glue_name = "${var.org}-${var.region}-${var.stack_env}-glue-job-mongodb"

    #VPC 
    vpc_name = "${var.org}-${var.region}-${var.stack_env}-vpc-consumer"
    igw_name = "${var.org}-${var.region}-${var.stack_env}-vpc-internet-gateway"
    private_rt_name = "${var.org}-${var.region}-${var.stack_env}-vpc-private-RT"
    public_rt_name = "${var.org}-${var.region}-${var.stack_env}-vpc-public-RT"
    private_subnet = "${var.org}-${var.region}-${var.stack_env}-vpc-private-subnet"
    public_subnet = "${var.org}-${var.region}-${var.stack_env}-vpc-public-subnet"
    s3_endpoint_name = "${var.org}-${var.region}-${var.stack_env}-vpc-s3-endpoint"
    nat_gateway_name = "${var.org}-${var.region}-${var.stack_env}-vpc-nat-gateway"
}
