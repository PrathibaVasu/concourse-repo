###dynamodb 


locals  {
  dynamodb_table = {
    "table1" = var.table1
    "table2" = var.table2 
    "table3" = var.table3 
  }
}


resource "aws_dynamodb_table" "basic-dynamodb-table" {

  for_each = local.dynamodb_table
  name           = each.value['name']
  billing_mode   = var.table_billing_mode
  read_capacity  = var.rcu
  write_capacity = var.wrc
  hash_key       = each.value['hash_key']
  range_key      = each.value['range_key']

  attribute {
    name = each.value['hash_key']
    type = each.value['hask_key_type']
  }

  attribute {
    name = each.value['range_key']
    type = each.value['range_key_type']
  }

  tags = var.tags 
}


/*
module "dynamodb_table" {
  source   = "terraform-aws-modules/dynamodb-table/aws"

  name     = var.table_name
  hash_key    = var.hash_key
  range_key   = var.range_key
  table_class = "STANDARD"

  attributes = [
    {
      name = var.hash_key
      type = "N"
    },
    {
      name = var.range_key
      type = "S"
    },
  ]

  tags = var.tags
}
*/