resource "helm_release" "argocd" {
  name  = "argocd"
  chart = "argo-cd"

  repository = "https://argoproj.github.io/argo-helm"

  namespace        = var.argocd_namespace
  create_namespace = true
}