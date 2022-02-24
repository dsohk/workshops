# Configure Rancher managed Kubernetes log forwarding to ECK (Elastic Search on Kubernetes)

Rancher
1. Go to cluster2
2. Apps -> add chart rodeo https://rancher.github.io/rodeo
3. Deploy rancher-demo
4. Cluster Tools -> Enable logging
5. Storage > Secrets > Create (elastic)
6. Logging 
    1. Outputs => http (not s) 

https://banzaicloud.com/docs/one-eye/logging-operator/configuration/plugins/outputs/elasticsearch/

Deployment example
https://banzaicloud.com/docs/one-eye/logging-operator/quickstarts/es-nginx/



## ECK 

After login with elastic user,

1. Stack Management > Kibana/Index Patterns
2. Create new index patterns > demo-*
3. Analytics > Discover



