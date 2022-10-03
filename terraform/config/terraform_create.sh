#!/bin/bash

ls -lrth
pwd
cd ../..
pwd 
mkdir ./temp
find ./terraform -name '*.tf*' -exec cp {} ./temp/ \;
cp -r ./terraform ./temp
cd ./temp
pwd 
ls -lrth
terraform init
terraform plan