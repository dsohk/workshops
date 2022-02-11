#! /bin/bash

terraform state rm module.longhorn.helm_release.longhorn
terraform state rm module.longhorn.time_sleep.wait_30_seconds
terraform state rm module.elastic.time_sleep.wait_15_seconds
terraform state rm module.elastic.data.kubernetes_secret.elastic_password
terraform destroy --auto-approve

