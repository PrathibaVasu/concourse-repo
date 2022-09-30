
module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  acl    = "private"
  bucket = "terraform-test-bucket1456"  #local.bucket_name
  tags = {
    ENV = "TEST"
  }

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true 

  versioning = {
    status     = true
  }
}
