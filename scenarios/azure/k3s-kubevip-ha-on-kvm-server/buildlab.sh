#! /bin/bash

# Create an attendee lab
for i in {03..10}
do
sleep 5s

export ATTENDEE=attendee$i

cat <<EOF | kubectl create -f -
---
apiVersion: apps/v1
kind: Deployment
metadata:
  annotations:
    field.cattle.io/description: Build lab with terraform for $ATTENDEE
  labels:
    app: buildlab-$ATTENDEE
  name: buildlab-$ATTENDEE
  namespace: buildlab
spec:
  replicas: 1
  selector:
    matchLabels:
      app: buildlab-$ATTENDEE
  template:
    metadata:
      labels:
        app: buildlab-$ATTENDEE
    spec:
      initContainers:
      - name: gitclone
        image: susesamples/terraform:1.1   
        command: ["/bin/sh", "-c", "--"]
        args: ["rm -rf /workspace/* && git clone https://github.com/dsohk/workshops.git /workspace"]
        # args: ["rm -rf /workspace/* && git clone https://\$GIT_USERNAME:\$GIT_PASSWORD@github.com/dsohk/workshops.git /workspace"]
        env:
        - name: GIT_USERNAME
          valueFrom:
            secretKeyRef:
              name: my-github
              key: username
        - name: GIT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: my-github
              key: password
        volumeMounts:
        - name: workspace
          mountPath: "/workspace"    
      containers:
      - name: terraform
        image: susesamples/terraform:1.1
        resources:
          limits:
            cpu: "1000m"
            memory: "1024Mi"
          requests:
            cpu: "250m"
            memory: "128Mi"        
        args: ["cd /workspace/scenarios/azure/rancher-neuvector && sh buildlab.sh && while true; do sleep 15s; done;"]
        command: ["/bin/sh", "-c", "--"]
        env:
        - name: POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name        
        - name: TF_LOG
          value: WARN
        - name: TF_LOG_PATH
          value: /dev/stdout
        - name: TF_INPUT
          value: "0"
        - name: AZ_SAS_TOKEN
          valueFrom:
            secretKeyRef:
              name: my-tfvars
              key: azure_sas_token
        - name: AZ_STORAGE_ACCOUNT
          value: "rancherworkshop"
        - name: AZ_BLOB_CONTAINER
          value: "lab"           
        - name: TF_VAR_azure_subscription_id
          valueFrom:
            secretKeyRef:
              name: my-tfvars
              key: azure_subscription_id
        - name: TF_VAR_azure_tenant_id
          valueFrom:
            secretKeyRef:
              name: my-tfvars
              key: azure_tenant_id
        - name: TF_VAR_azure_client_id
          valueFrom:
            secretKeyRef:
              name: my-tfvars
              key: azure_client_id
        - name: TF_VAR_azure_client_secret
          valueFrom:
            secretKeyRef:
              name: my-tfvars
              key: azure_client_secret                             
        - name: TF_VAR_azure_location
          value: "Central India"
        - name: TF_VAR_prefix
          value: "cl"
        - name: TF_VAR_resource_group_name
          value: "$ATTENDEE"
        - name: TF_VAR_tag_department
          value: "GSO"
        - name: TF_VAR_tag_environment
          value: "Workshop"
        - name: TF_VAR_tag_group
          value: "pre-sales"
        - name: TF_VAR_tag_project
          value: "Crimsonlogic Workshop"
        - name: TF_VAR_tag_resource_owner
          value: "derek.so@suse.com"
        - name: TF_VAR_tag_stakeholder
          value: "Peter Lees"          
        volumeMounts:
          - name:  workspace
            mountPath:  "/workspace"
      volumes:
      - name: workspace
        hostPath:
          path: /workspace/buildlab-$ATTENDEE
          type: DirectoryOrCreate
EOF


done



