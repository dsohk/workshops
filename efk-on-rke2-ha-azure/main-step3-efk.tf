# Install Elastic Operator

data "http" "elastic_crd_url" {
  url = "https://download.elastic.co/downloads/eck/${var.eck_version}/crds.yaml"
}

data "http" "elastic_op_url" {
  url = "https://download.elastic.co/downloads/eck/${var.eck_version}/operator.yaml"
}

data "kubectl_file_documents" "elastic_crds" {
  content = data.http.elastic_crd_url.body
}

data "kubectl_file_documents" "elastic_op" {
  content = data.http.elastic_op_url.body
}

resource "kubectl_manifest" "apply_elastic_crds" {
  for_each  = data.kubectl_file_documents.elastic_crds.manifests
  yaml_body = each.value
}

resource "kubectl_manifest" "apply_elastic_op" {
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
  yaml_body = <<YAML
apiVersion: elasticsearch.k8s.elastic.co/v1
kind: Elasticsearch
metadata:
  name: rancher-workshop
  namespace: elastic-system
spec:
  version: 7.15.0
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
        storageClassName: longhorn
YAML
}

# Deploy Kibana

resource "kubectl_manifest" "kibana" {
  yaml_body = <<YAML
apiVersion: kibana.k8s.elastic.co/v1
kind: Kibana
metadata:
  name: rancher-workshop
  namespace: elastic-system
spec:
  version: 7.15.0
  count: 1
  elasticsearchRef:
    name: rancher-workshop
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

data "kubernetes_secret" "elastic_password" {
  depends_on = [kubectl_manifest.elasticsearch_cluster]
  metadata {
    name      = "rancher-workshop-es-elastic-user"
    namespace = "elastic-system"
  }
  binary_data = {
    "elastic" = ""
  }
}
