# Lab 1 - Rancher Onboarding Experience Tour

This terraform script will build out an environment as follows.

1. Single Node VM hosting the following

* Rancher Server 2.6.3 on RKE2
* Keycloak Server
* Elastic and Kibana

2. Two downstream all-in-one RKE2-based clusters managed by the Rancher Server

Once the lab environment is ready, we will show you

1. How to configure Rancher Server to have single sign-on with Keycloak Server

2. How to configure and ship the logs from Kubernetes to ElasticSearch

