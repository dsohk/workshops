# 10 Things to Show for Cloud Native Security with Neuvector

## 1. Change initial password and lengthen login session time

* Login to Neuvector as admin with default password
* Goto 

## 2 Node, Container and Registry scanning

Assets > Registries

Docker:
* name: demo
* URL:  https://registry.hub.docker.com/
Filter: 
* nvbeta/*
* skywalke34/*
* elastic/logstash:7.13.3

## 3. Admission Control

Policy > Admission Control

Add: Add
* Comment: Basic Rules for all containers
* Criteria: PSP Best Practice, More than 0 high severity CVEs with fix that were reported 14 days ago; Image scanned= false
* Status: Enabled
* Click Add

Turn Status = enabled
Mode = Monitor

## 3. Zero-trust Runtime Security

Policy > Groups - Move Pods in namespace from Discover to Monitor/Protect

