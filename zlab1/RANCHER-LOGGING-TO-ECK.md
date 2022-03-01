# Configure Rancher managed Kubernetes log forwarding to ECK (Elastic Search on Kubernetes)

## Setup Rancher for log shipping
1. Go to cluster1
4. Cluster Tools -> Enable logging
5. Storage > Secrets > Create (elastic)
6. configure ClusterOutput (refer to yaml below)
7. Deploy sample app (refer to yaml below)
8. configure Flow (refer to yaml below)

## Configure EFK

After login with elastic user,

1. Main Menu > Stack Management > Kibana/Index Patterns
2. Create new index patterns > fluentd
3. Analytics > Discover (To show the logs)

Example:

https://banzaicloud.com/docs/one-eye/logging-operator/configuration/plugins/outputs/elasticsearch/

Deployment example
https://banzaicloud.com/docs/one-eye/logging-operator/quickstarts/es-nginx/



--------------------------------

# create secret
apiVersion: v1
kind: Secret
metadata:
  name: my-elasticsearch
type: Opaque
data:
  password: (Your own elastic password in base64)



# define output

apiVersion: logging.banzaicloud.io/v1beta1
kind: ClusterOutput
metadata:
  name: my-elasticsearch
spec:
  elasticsearch:
    host: 20.204.177.36
    port: 30001
    scheme: https
    ssl_verify: false
    ssl_version: TLSv1_2
    user: elastic
    password:
      valueFrom:
        secretKeyRef:
          name: my-elasticsearch
          key: password
    include_timestamp: true
    buffer:
      timekey: 1m
      timekey_wait: 30s
      timekey_use_utc: true


# define flow

apiVersion: logging.banzaicloud.io/v1beta1
kind: Flow
metadata:
  name: my-applog
spec:
  filters:
    - tag_normaliser: {}
    - parser:
        remove_key_name_field: true
        reserve_data: true
        parse:
          type: nginx
  match:
     - select:
         labels:
           app.kubernetes.io/name: log-generator
  localOutputRefs:
    - my-elasticsearch

# define sample app to generate logs

apiVersion: apps/v1
kind: Deployment
metadata:
 name: log-generator
spec:
 selector:
   matchLabels:
     app.kubernetes.io/name: log-generator
 replicas: 1
 template:
   metadata:
     labels:
       app.kubernetes.io/name: log-generator
   spec:
     containers:
     - name: nginx
       image: banzaicloud/log-generator:0.3.2




