#!/bin/bash

ls -lrth
cd ../..
mkdir ./temp
find ./terraform -name '*.tf*' -exec cp {} ./temp/ \;
cp -r ./terraform ./temp
cd ./temp
ls -lrth
terraform init
terraform plan