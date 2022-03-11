# Rancher Server Shared Terraform Module

This `rancher` terraform module helps managing resources required to deploy 
an instance of Rancher Server, regardless of the underlying cloud provider. 
The Rancher Server will be running on a given single node with RKE2 installed.

## Variables

###### `node_public_ip`
- **Required**
Public IP of compute node for Rancher Server

###### `node_internal_ip`
- Default: **`""`**
Internal IP of compute node for Rancher Server

###### `node_username`
- **Required**
Username used for SSH access to the Rancher Server node

###### `ssh_private_key_pem`
- **Required**
Private key used for SSH access to the Rancher Server node


###### `rancher_kubernetes_version`
- Default: **`"v1.21.8+k3s1"`**
Kubernetes version to use for Rancher server cluster

###### `cert_manager_version`
- Default: **`"1.7.0"`**
Version of cert-manager to install alongside Rancher (format: `0.0.0`)

###### `rancher_version`
- Default: **`"v2.6.3"`**
Rancher server version (format `v0.0.0`)

###### `rancher_server_dns`
- **Required**
DNS host name of the Rancher server

A DNS name is required to allow successful SSL cert generation.
SSL certs may only be assigned to DNS names, not IP addresses.
Only an IP address could cause the Custom cluster to fail due to mismatching SSL
Subject Names.

###### `admin_password`
- **Required**
Admin password to use for Rancher server bootstrap

Log in to the Rancher server using username `admin` and this password.

