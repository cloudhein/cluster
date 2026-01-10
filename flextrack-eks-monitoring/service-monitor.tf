resource "kubectl_manifest" "service_monitors" {
  for_each = toset(local.service_monitor_files)

  yaml_body = file("${path.module}/prometheus-config/${each.value}")

  depends_on = [
    helm_release.kube_prometheus_stack
  ]

}