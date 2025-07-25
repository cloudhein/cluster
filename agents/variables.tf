variable "argocd_namespace" {
  type        = string
  description = "Namespace to install ArgoCD"
  default     = "argocd"
}

variable "ingress_nginx_namespace" {
  type        = string
  description = "Namespace for NGINX Ingress Controller"
  default     = "ingress-nginx"
}

variable "argocd_apps" {
  type = list(
    object({
      app-name        = string
      repository-url  = string
      target-revision = string
      source-path     = string
      server-url      = string
  }))
  description = "ArgoCD applications to install"
}
