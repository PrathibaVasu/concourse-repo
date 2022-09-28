module "test_resources_glue" {
    source = "../modules/glue"
    #tags = var.tags 


    #Glue 
    python_version = var.python_version
    no_of_workers = var.no_of_workers
    script_location = var.script_location

}
