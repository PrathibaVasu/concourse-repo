
resource "aws_dynamodb_table" "test-table" {
  #provider = aws.region
  name           = var.table_name
  billing_mode   = var.table_billing_mode
  hash_key       = var.hash_key
  read_capacity  = 5
  write_capacity = 5
  attribute {
    name = var.hash_key
    type = "S"
  }
  #tags = var.tags
}

