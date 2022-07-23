# Rancher Hands-on Workshop Series

This repository contains a collection of terraform scripts to help you provision an environment for getting the first-hand experience of open source technologies such as Kubernetes, Rancher, Longhorn, Neuvector, etc.

## System Requirements

1. terraform
2. helm

## Start my Rancher Server on the Cloud

Automate your very first instance of Rancher Server deployment on a cloud provider:

1. [AWS](./scenarios/aws-ec2/rancher-server)
2. Azure
    * [Rancher Server on Single Node](./scenarios/azure/rancher-server)
    * [HA-enabled Rancher Server on 3-Node Cluster](./scenarios/azure/rancher-server-ha)
3. [Google Cloud Platform](./scenarios/gcp/rancher-server)

## Hands-on Workshop

1. [Rancher with Keycloak SSO + Log Forwarding to ElasticSearch](./scenarios/azure/rancher-keycloak-elastic)
2. [Deploy and Manage Microservices with Rancher, Istio and NeuVector](./scenarios/azure/rancher-neuvector)
3. [Rancher and Private Registry - Harbor and Azure Container Registry](./scenarios/azure/rancher-harbor-acr)


## Contributing to this repository

TODO: Move terraform state to Azure Storage

https://docs.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli


## Reference

This repository starts from referring to [`rancher-quickstart`](https://github.com/rancher/quickstart) project and evolves from there. 

