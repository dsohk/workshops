# OpenSUSE Linux Server with Cockpit WebConsole

## Introduction

This terraform script will build out an environment as follows.

Linux server instances with cockpit web console preinstalled

## Setup

Login to your Azure portal, start the [Cloud Shell](https://docs.microsoft.com/en-us/azure/cloud-shell/overview) with bash environment, run the following command to start the lab.

```
git clone https://github.com/dsohk/workshops
cd workshops/scenarios/azure/linux-server-cockpit
./startlab.sh
```

The `startlab.sh` script downloads and installs terraform and helm binaries on your cloud shell environment. Then, it extracts the azure client credentials from your azure login session and updates credentials in the `terraform.tfvars` file. Lastly, it kicks off the terraform commands to build the environment. 


## Lab Guide after Setup finished

Once the lab environment is ready, follow the [lab guide]() which guides you to the followings:


