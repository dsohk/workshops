#! /bin/bash -ex

# Run this in Cloud Shell

# Download terraform binary
# TF_VERSION=1.1.2
# TF_BIN=$HOME/bin/terraform
# if [ -f "$TF_BIN" ]; then
#   wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip
#   unzip terraform_${TF_VERSION}_linux_amd64.zip
#   mkdir -p $HOME/bin
#   mv terraform $TF_BIN
#   terraform -install-autocomplete
# fi

terraform init
terraform plan
terraform apply --auto-approve
