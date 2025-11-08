# Install Fluent Bit
resource "helm_release" "fluent_bit" {
  name       = "fluent-bit"
  repository = "https://fluent.github.io/helm-charts"
  chart      = "fluent-bit"
  namespace  = kubernetes_namespace.logging.metadata[0].name

  values = [
    file("${path.module}/fluentbit-config/fluentbit-values.yaml")
  ]

  timeout = var.helm_timeout # Increased timeout
  wait    = false            # Don't wait for all pods to be ready

  depends_on = [
    helm_release.elasticsearch,
    kubernetes_secret.elasticsearch_credentials_for_fluentbit
  ]
}