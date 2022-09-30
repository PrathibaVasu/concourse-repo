#!/bin/bash

cd terraform-resources/

mkdir ./terraform/temp 
chmod +x ./terraform/config/terraform_create.sh

find ./terraform -name '*.tf*' '*.py' -exec cp {} ./terraform/temp/ \;
cd /terraform/temp
terraform init 
terraform plan
