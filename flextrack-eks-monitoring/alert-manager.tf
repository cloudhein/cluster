resource "kubectl_manifest" "alerting_configs" {
  for_each = local.alerting_configs

  yaml_body = file("${path.module}/prometheus-alert-config/${each.value}")


  depends_on = [
    helm_release.kube_prometheus_stack,
    kubernetes_secret_v1.slack_webhook
  ]
}

# Create Slack webhook secret 
resource "kubernetes_secret_v1" "slack_webhook" {
  metadata {
    name      = "slack-webhook-secret"
    namespace = var.monitoring_namespace
  }

  data = {
    url = var.slack_webhook_url
  }

  depends_on = [
    helm_release.kube_prometheus_stack
  ]
}

