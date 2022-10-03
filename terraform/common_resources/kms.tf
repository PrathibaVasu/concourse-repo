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
