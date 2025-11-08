# Install Elasticsearch
resource "helm_release" "elasticsearch" {
  name       = "elasticsearch"
  repository = "https://helm.elastic.co"
  chart      = "elasticsearch"
  namespace  = kubernetes_namespace.logging.metadata[0].name

  set = [
    {
      name  = "replicas"
      value = var.elasticsearch_replicas
    },
    {
      name  = "volumeClaimTemplate.resources.requests.storage"
      value = var.elasticsearch_storage_size
    }
  ]
  depends_on = [kubernetes_namespace.logging]
}

data "kubernetes_secret" "elasticsearch_credentials" {
  metadata {
    name      = "elasticsearch-master-credentials"
    namespace = var.logging_namespace
  }

  depends_on = [helm_release.elasticsearch]
}

# Create secret for Fluent Bit authenticatio
resource "kubernetes_secret" "elasticsearch_credentials_for_fluentbit" {
  metadata {
    name      = "elasticsearch-credentials"
    namespace = var.logging_namespace
  }

  data = {
    username = "elastic"
    password = data.kubernetes_secret.elasticsearch_credentials.data["password"]
  }

  type = "Opaque"
}
