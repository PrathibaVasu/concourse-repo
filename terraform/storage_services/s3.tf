
### S3 buckets creation  ###
module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  #bucket = var.bucket_name
  for_each = toset(local.s3_bucket_name)

  bucket = each.key 
  tags = local.tags
  acl    = "private"
  versioning = var.versioning

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true 

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
