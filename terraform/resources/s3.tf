
provider "aws" {
    region = "us-east-1"
}
 


module "test_resources_s3" {
    source = "../modules/s3"
    #S3
    region = var.region
    bucket_name = var.bucket_name 
    acl_value = var.acl_value 
    versioning = var.versioning 
    tags = var.tags 

}
