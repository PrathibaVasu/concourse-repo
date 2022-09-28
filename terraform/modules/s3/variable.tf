
###S3 
variable "bucket_name" {}

variable "acl_value" {}

variable "region" {}

variable "versioning" {}

variable "tags" {}



###Dynamodb 

variable "table_name" {}

variable "table_billing_mode" {}

variable "hash_key" {}



### Glue variables 
variable "python_version" {}

variable "no_of_workers" {}

variable "script_location" {}