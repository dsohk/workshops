# Install Elastic Operator
# https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-quickstart.html

data "http" "elastic_crd_url" {
  url = "https://download.elastic.co/downloads/eck/${var.eck_version}/crds.yaml"
}

data "http" "elastic_op_url" {
  url = "https://download.elastic.co/downloads/eck/${var.eck_version}/operator.yaml"
}

data "kubectl_file_documents" "elastic_crds" {
  provider = elastic-kubectl
  content  = data.http.elastic_crd_url.body
}

data "kubectl_file_documents" "elastic_op" {
  provider = elastic-kubectl
  content  = data.http.elastic_op_url.body
}

resource "kubectl_manifest" "apply_elastic_crds" {
  provider = elastic-kubectl
  for_each  = data.kubectl_file_documents.elastic_crds.manifests
  yaml_body = each.value
}

resource "kubectl_manifest" "apply_elastic_op" {
  provider = elastic-kubectl
  depends_on = [kubectl_manifest.apply_elastic_crds]
  for_each   = data.kubectl_file_documents.elastic_op.manifests
  yaml_body  = each.value
}

# Deploy an Elastic Search Cluster

# Wait for 15 seconds till elastic operator is fully initialized
resource "time_sleep" "wait_15_seconds" {
  depends_on      = [kubectl_manifest.apply_elastic_op]
  create_duration = "15s"
}


resource "kubectl_manifest" "elasticsearch_cluster" {
  depends_on = [time_sleep.wait_15_seconds]
  provider = elastic-kubectl
  yaml_body = <<YAML
apiVersion: elasticsearch.k8s.elastic.co/v1
kind: Elasticsearch
metadata:
  name: susedemo
  namespace: elastic-system
spec:
  version: 7.17.0
  http:
    service:
      spec:
        type: NodePort
        ports:
          - name: https
            nodePort: ${var.es_port}
            port: 9200
            protocol: TCP
            targetPort: 9200
  nodeSets:
  - name: default
    count: 1
    config:
      node.store.allow_mmap: false
    volumeClaimTemplates:
    - metadata:
        name: elasticsearch-data # Do not change this name unless you set up a volume mount for the data path.
      spec:
        accessModes:
        - ReadWriteOnce
        resources:
          requests:
            storage: 5Gi
        storageClassName: ${var.storage_class_name}
YAML
}

# Deploy Kibana

resource "kubectl_manifest" "kibana" {
  provider = elastic-kubectl
  depends_on = [time_sleep.wait_15_seconds]
  yaml_body = <<YAML
apiVersion: kibana.k8s.elastic.co/v1
kind: Kibana
metadata:
  name: susedemo
  namespace: elastic-system
spec:
  version: 7.17.0
  count: 1
  elasticsearchRef:
    name: susedemo
  http:
    service:
      spec:
        type: NodePort
        ports:
          - name: https
            nodePort: ${var.kb_port}
            port: 5601
            protocol: TCP
            targetPort: 5601    
  podTemplate:
    spec:
      containers:
      - name: kibana
        resources:
          limits:
            memory: 1Gi
            cpu: 1
YAML
}

# define ingress URL for elasticsearch and kibana

data "kubernetes_secret" "elastic_password" {
  provider = elastic-kubernetes
  depends_on = [kubectl_manifest.elasticsearch_cluster]
  metadata {
    name      = "susedemo-es-elastic-user"
    namespace = "elastic-system"
  }
  binary_data = {
    "elastic" = ""
  }
}

