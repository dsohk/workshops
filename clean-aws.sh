#! /bin/bash

cd aws
terraform state rm module.rancher_server.helm_release.rancher_server
terraform state rm module.rancher_server.helm_release.cert_manager
terraform destroy --auto-approve

