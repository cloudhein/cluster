resource "kubectl_manifest" "argocd_application" {
  for_each = local.argocd_apps

  yaml_body = templatefile("${path.module}/config/application.yaml.tmpl", {
    app-name        = each.value.app-name
    app-deployed-ns = each.value.app-deployed-ns
    server-url      = each.value.server-url
    repository-url  = each.value.repository-url
    target-revision = each.value.target-revision
    source-path     = each.value.source-path
  })

  depends_on = [helm_release.argocd]
}
