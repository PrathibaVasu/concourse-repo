
module "test_resources" {
    source = "../modules/s3"
    #S3
    region = var.region
    bucket_name = var.bucket_name 
    acl_value = var.acl 
    versioning = var.versioning 
    tags = var.tags 

}