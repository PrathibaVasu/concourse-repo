#!/bin/bash

cd terraform-resources/
mkdir ./terraform/temp 

find ./terraform -name '*.tf*' -exec cp {} ./terraform/temp/ \;
cd /terraform/temp
terraform init 
terraform plan
