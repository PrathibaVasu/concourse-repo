module "test_resources_dynamodb" {
    source = "../modules/dynamodb"


    tags = var.tags 

    table_name         = var.table_name
    table_billing_mode = var.table_billing_mode
    hash_key           = var.hash_key


}