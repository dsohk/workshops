#! /bin/bash

terraform init

retry=0
while [ $retry -le 5 ]
do
  terraform plan -out tfplan 
  terraform apply -auto-approve tfplan
  status=$?
  if [ $status -ne 0 ]; then
    echo "terraform apply failed with exit code: $status "
    echo "retrying after 15s ..."
    sleep 15s
    retry=$(( $retry + 1 ))
  else
    break
  fi
done
terraform output -json > tf-output.json

WEBFILE=$POD_NAME
# WEBFILE=labattendee1
# RANDOMSTRING=`openssl rand -hex 10`
UPLOAD_FILE=tf-output.json
DATE_NOW=$(date -Ru | sed 's/\+0000/GMT/')
AZ_VERSION="2020-08-04"
# AZ_STORAGE_ACCOUNT="rancherworkshop"
# AZ_BLOB_CONTAINER="lab"
# AZ_SAS_TOKEN="..."
AZ_BLOB_URL="https://${AZ_STORAGE_ACCOUNT}.blob.core.windows.net"
AZ_BLOB_TARGET="${AZ_BLOB_URL}/${AZ_BLOB_CONTAINER}/"

curl -X PUT \
  -H "Content-Type: application/octet-stream" \
  -H "x-ms-date: ${DATE_NOW}" \
  -H "x-ms-version: ${AZ_VERSION}" \
  -H "x-ms-blob-type: BlockBlob" \
  --data-binary "@${UPLOAD_FILE}" "${AZ_BLOB_TARGET}${WEBFILE}.json?${AZ_SAS_TOKEN}"

echo "Lab has been provisioned successfully. Credentials are uploaded to ..."
echo "${AZ_BLOB_URL}/${AZ_BLOB_CONTAINER}/${WEBFILE}.json"
echo
echo "Bye!"

