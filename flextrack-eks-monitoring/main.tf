resource "helm_release" "kube_prometheus_stack" {
  name  = var.monitoring_release_name
  chart = "kube-prometheus-stack"

  repository = "https://prometheus-community.github.io/helm-charts"

  namespace        = var.monitoring_namespace
  create_namespace = true

  for_each = toset(local.custom_prometheus_values)

  values = [
    file("${path.module}/prometheus-config/${each.value}")
  ]
}