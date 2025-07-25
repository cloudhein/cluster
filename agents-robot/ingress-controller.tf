resource "helm_release" "nginx_ingress" {
  name = "nginx-ingress"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  namespace        = var.ingress_nginx_namespace
  create_namespace = true

  depends_on = [helm_release.argocd]
}