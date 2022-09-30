###dynamodb 

module "dynamodb_table" {
  source   = "terraform-aws-modules/dynamodb-table/aws"

  name     = "terraform-test-table"
  hash_key    = "id"
  range_key   = "title"
  table_class = "STANDARD"

  attributes = [
    {
      name = "id"
      type = "N"
    },
    {
      name = "title"
      type = "S"
    },
  ]

  tags = {
    Terraform   = "true"
    Environment = "staging"
  }
}
