resource "helm_release" "elastalert2" {
  name       = "elastalert2"
  repository = "https://jertel.github.io/elastalert2"
  chart      = "elastalert2"
  namespace  = kubernetes_namespace.logging.metadata[0].name

  values = [
    file("${path.module}/elastalert2-config/elastalert2-values.yaml")
  ]

  depends_on = [
    helm_release.elasticsearch,
    kubernetes_secret.slack_webhook
  ]
}

resource "kubernetes_secret" "slack_webhook" {
  metadata {
    name      = "slack-webhook-secret"
    namespace = kubernetes_namespace.logging.metadata[0].name
  }

  data = {
    webhook-url = var.slack_webhook_url
  }

  type = "Opaque"
}