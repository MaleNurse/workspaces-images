#! /usr/bin/env bash

set -ex

TF_IN_AUTOMATION=true
CURRENT_DIR=$(pwd)

if [ -f ./terraform.tfvars ]; then
  export TF_CLI_ARGS_apply="-var-file=$CURRENT_DIR/terraform.tfvars"
fi

wing compile -t tf-aws main.w
cd ./target/main.tfaws
terraform init
terraform apply -state=../../terraform.tfstate



