# Rancher Server + Neuvector

## Introduction

This terraform script will build out an environment as follows.

1. Single Node VM with the following software components installed.

* Rancher Server 2.6.3 on RKE2

2. One downstream all-in-one RKE2-based cluster with Neuvector deployed on it.

## Setup

Login to your Azure portal, start the [Cloud Shell](https://docs.microsoft.com/en-us/azure/cloud-shell/overview) with bash environment, run the following command to start the lab.

```
git clone https://github.com/dsohk/rancher-hands-on-workshops
cd rancher-hands-on-workshops/scenarios/azure/rancher-neuvector
./startlab.sh
```

The `startlab.sh` script downloads and installs terraform and helm binaries on your cloud shell environment. Then, it extracts the azure client credentials from your azure login session and updates credentials in the `terraform.tfvars` file. Lastly, it kicks off the terraform commands to build the environment. 


## Lab Guide after Setup finished

Once the lab environment is ready, follow the [lab guide]() which guides you to the followings:


