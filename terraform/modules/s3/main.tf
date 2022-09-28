provider "aws" {
  alias  = "region"
  region = var.region
}

resource "aws_s3_bucket" "demo-s3-bucket" {
    #provider = aws.region 

    bucket        = var.bucket_name
    acl           = var.acl_value
    force_destroy = true
    tags          = var.tags 
    versioning {
        enabled = var.versioning 
    }    
}


