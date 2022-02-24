#! /bin/bash -ex

# Run this in Azure Cloud Shell

# Always Download and install terraform
TF_VERSION=1.1.6
TF_BIN=$HOME/bin/terraform
wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip
unzip terraform_${TF_VERSION}_linux_amd64.zip
mkdir -p $HOME/bin
mv terraform $TF_BIN
rm terraform_${TF_VERSION}_linux_amd64.zip
terraform -install-autocomplete

# Download and install helm utility
HELM_VERSION=3.8.0
HELM_BIN=$HOME/bin/helm
if [ ! -f "$HELM_BIN" ]; then
  wget https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz
  tar xvf helm-v${HELM_VERSION}-linux-amd64.tar.gz
  mkdir -p $HOME/bin
  mv linux-amd64/helm $HELM_BIN
  rm -rf linux-amd64
  rm helm-v${HELM_VERSION}-linux-amd64.tar.gz
  helm version
fi

# Setup Azure credentials for provisioning resources with Terraform scripts

## Configure auto extension installation for az cli
az config set extension.use_dynamic_install=yes_without_prompt

## Find tenantId and subscriptionId of currently signed in user
TENANT_ID=`az account list | jq -r .[0].tenantId`
SUBSCRIPTION_ID=`az account subscription list | jq -r .[0].subscriptionId`

## Create or patch existing service pricinpal
SERVICE_PRINCIPAL_NAME=`az account list | jq -r .[0].user.name | sed 's/[\@._+]/-/g'`
az ad sp create-for-rbac \
  --name $SERVICE_PRINCIPAL_NAME \
  --role contributor \
  --scopes /subscriptions/$SUBSCRIPTION_ID > $SERVICE_PRINCIPAL_NAME.json

## Capture the Client Id/secret
CLIENT_ID=`jq -r .appId $SERVICE_PRINCIPAL_NAME.json`
CLIENT_SECRET=`jq -r .password $SERVICE_PRINCIPAL_NAME.json`
rm $SERVICE_PRINCIPAL_NAME.json

# Configure terraform.tfvars
cp terraform.tfvars.example terraform.tfvars
sed -i /^azure_subscription_id/c\azure_subscription_id=\"$SUBSCRIPTION_ID\" terraform.tfvars
sed -i /^azure_tenant_id/c\azure_tenant_id=\"$TENANT_ID\" terraform.tfvars
sed -i /^azure_client_id/c\azure_client_id=\"$CLIENT_ID\" terraform.tfvars
sed -i /^azure_client_secret/c\azure_client_secret=\"$CLIENT_SECRET\" terraform.tfvars
terraform fmt

# Lastly, kick of the terraform scripts
terraform init
touch ./kube_config_server.yaml
terraform plan
TF_LOG=DEBUG terraform apply --auto-approve

