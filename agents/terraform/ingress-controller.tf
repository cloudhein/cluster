resource "helm_release" "nginx_ingress" {
  name = "nginx-ingress"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  namespace        = var.ingress_nginx_namespace
  create_namespace = true

  set = [
    {
      name  = "controller.admissionWebhooks.enabled"
      value = "false"
    },
    {
      name  = "controller.allowSnippetAnnotations"
      value = "true"
    }
  ]

  depends_on = [helm_release.argocd]
}