
### S3 buckets creation  ###
module "staging_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"


  bucket = local.staging_bucket_name
  tags = local.tags
  acl    = "private"
  versioning = var.versioning

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true 

  #bucket-policy 
  attach_policy = true
  policy        = data.aws_iam_policy_document.staging_bucket_policy.json



  #Encrypting the bucket with KMS key 
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = aws_kms_key.s3_kms_key.arn
        sse_algorithm     = "aws:kms"
      }
      bucket_key_enabled = true
    }
  }
}


module "integration_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"


  bucket = local.integration_bucket_name 
  tags = local.tags
  acl    = "private"
  versioning = var.versioning

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true 

  # Bucket Policy  
  attach_policy = true
  policy        = data.aws_iam_policy_document.integration_bucket_policy.json

  #Encrypting the bucket with KMSkey 
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = aws_kms_key.s3_kms_key.arn
        sse_algorithm     = "aws:kms"
      }
      bucket_key_enabled = true
    }
  }

}

