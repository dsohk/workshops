# Rancher Server + Keycloak + Elastic

## Introduction

This terraform script will build out an environment as follows.

1. Single Node VM with the following software components installed.

* Rancher Server 2.6.3 on RKE2
* Keycloak Server version (Using helm chart version 16.0.5)
* Elastic and Kibana version (version 7.19)

2. Two downstream all-in-one RKE2-based clusters managed by the Rancher Server.

## Setup

Login to your Azure portal, start the [Cloud Shell](https://docs.microsoft.com/en-us/azure/cloud-shell/overview) with bash environment, run the following command to start the lab.

```
git clone https://github.com/dsohk/rancher-hands-on-workshops
cd rancher-hands-on-workshops/scenarios/azure/rancher-keycloak-elastic
./startlab.sh
```

The `startlab.sh` script downloads and installs terraform and helm binaries on your cloud shell environment. Then, it extracts the azure client credentials from your azure login session and updates credentials in the `terraform.tfvars` file. Lastly, it kicks off the terraform commands to build the environment. 


## Lab Guide after Setup finished

Once the lab environment is ready, follow the [lab guide](https://github.com/dsohk/rancher-keycloak-efk-integration-workshop) which guides you to the followings:

1. How to configure Rancher Server to have single sign-on with Keycloak Server

2. How to configure and ship the logs from Kubernetes to ElasticSearch

