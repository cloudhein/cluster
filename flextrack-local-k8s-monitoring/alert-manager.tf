resource "kubectl_manifest" "alerting_configs" {
  for_each = local.alerting_configs

  yaml_body = file("${path.module}/prometheus-alert-config/${each.value}")


  depends_on = [
    helm_release.kube_prometheus_stack,
    kubectl_manifest.slack_webhook_secret
  ]
}

# Create Slack webhook secret using kubectl_manifest (works better than kubernetes_secret)
resource "kubectl_manifest" "slack_webhook_secret" {
  yaml_body = yamlencode({
    apiVersion = "v1"
    kind       = "Secret"
    metadata = {
      name      = "slack-webhook-secret"
      namespace = var.monitoring_namespace
    }
    type = "Opaque"
    data = {
      url = base64encode(var.slack_webhook_url)
    }
  })

  depends_on = [
    helm_release.kube_prometheus_stack
  ]

  sensitive_fields = [
    "data.url"
  ]
}