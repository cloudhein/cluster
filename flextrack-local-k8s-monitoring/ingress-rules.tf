resource "kubectl_manifest" "ingress_rules" {
  for_each = toset(local.ingress_rule_files)

  yaml_body = file("${path.module}/ingress-config/${each.value}")

  depends_on = [
    helm_release.kube_prometheus_stack,
    helm_release.nginx_ingress
  ]

}