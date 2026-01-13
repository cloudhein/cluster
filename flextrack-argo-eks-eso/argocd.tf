resource "helm_release" "argocd" {
  name  = "argocd"
  chart = "argo-cd"

  repository = "https://argoproj.github.io/argo-helm"

  namespace        = var.argocd_namespace
  create_namespace = true

  timeout = var.helm_timeout # Increased timeout
  wait    = false            # Don't wait for all pods to be ready

  # ✅ ADDED: Load the fixed values file to set Resource Requests
  values = [
    file("${path.module}/config/argocd-values-fixed.yaml")
  ]
}