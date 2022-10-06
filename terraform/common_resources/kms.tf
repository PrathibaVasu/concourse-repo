
#kms 

resource "aws_kms_key" "s3_kms_key" {
  description              = "This kms key is used for encrypting s3 buckets"
  enable_key_rotation      = true  
  tags                    = local.tags 
}


resource "aws_kms_key" "dynamodb_kms_key" {
  description              = "This kms key is used for encrypting s3 buckets"
  enable_key_rotation      = true  
  tags                    = local.tags 
}