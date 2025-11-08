# Install Kibana
resource "helm_release" "kibana" {
  name       = "kibana"
  repository = "https://helm.elastic.co"
  chart      = "kibana"
  namespace  = kubernetes_namespace.logging.metadata[0].name

  set = [
    {
      name  = "service.type"
      value = var.kibana_service_type
    }
  ]
  depends_on = [
    helm_release.elasticsearch,
    kubernetes_secret.elasticsearch_credentials_for_fluentbit
  ]
}