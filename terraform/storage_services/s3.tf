
locals  {
  s3_bucket_name = [var.staging_bucket_name, var.landing_bucket_name]
}



module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  #bucket = var.bucket_name
  for_each = toset(local.s3_bucket_name)

  bucket = each.key 
  tags = var.tags
  acl    = "private"

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true 

  versioning = var.versioning

/*
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = local.kms_arn_map[each.value["datasource_id"]]["arn"]
        sse_algorithm     = "aws:kms"
      }
      bucket_key_enabled = false
    }
  }
*/

}


/*

# KMS key used for encrypting s3 buckets,kinesis streams,cloudwatch logs
module "data_lake_s3_bucket_kms_key" {
  source  = "app.terraform.io/dummy/kms/aws"
  version = "0.0.12"
  for_each = {
    for object in local.s3_raw_bucket : object["datasource_id"] => object
  }
  description              = "This kms key is used for encrypting s3 buckets,kinesis streams,cloudwatch logs"
  enable_key_rotation      = true
  kms_key_admin_principals = var.data_lake_s3_bucket_kms_key_admin_principals
  kms_key_usage_principals = var.data_lake_s3_bucket_kms_key_usage_principals
  kms_key_usage_services = var.data_lake_s3_bucket_kms_key_usage_services
  alias_name             = each.value["kms_key"]
  name                   = each.value["kms_key"]
  owner                  = var.owner
  env                    = var.env

}

# Create map of KMS key with ARNs, alias, IDs
locals {
  kms_arn_map = module.data_lake_s3_bucket_kms_key
}
*/