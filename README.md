# SUSE Cloud-Native Hands-on Workshop Series

This is a series of hands-on workshops and demos to learn cloud-native technologies with Rancher, Longhorn, Neuvector, Harvester, and more.

## Pre-requisites

1. terraform 
2. terragrunt
3. helm

## Start my Rancher Server on the Cloud

Automate your very first instance of Rancher Server deployment on a cloud provider:

1. [AWS](./rancher-server-aws-ec2)
2. [Azure](./rancher-server-azure)
3. [Google Cloud Platform](./rancher-server-google-cloud-platform)

## Hands-on Lab Series

### Lab 1 - Onboarding Rancher Workshop

You will learn how to ...

* configure Rancher Server to have Keycloak as IdP for single-sign on.
* enable audit logging and forward all the logs to a EFK cluster.

This lab runs on Microsoft Azure. Please login to your Azure Portal and open Cloud Shell. At the bash terminal in the Cloud Shell, run the following commands to start the lab.

```
git clone https://github.com/dsohk/rancher-hands-on-workshops
cd rancher-hands-on-workshops/zlab1
./startlab.sh
```



## Contributing to this repository

TODO: Move terraform state to Azure Storage

https://docs.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli


## Reference

This repository starts from referring to [`rancher-quickstart`](https://github.com/rancher/quickstart) project and evolves from there. 

