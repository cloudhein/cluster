variable "argocd_namespace" {
  type        = string
  description = "Namespace to install ArgoCD"
  default     = "argocd"
}

variable "argocd_apps" {
  type = list(
    object({
      app-name        = string
      repository-url  = string
      target-revision = string
      source-path     = string
      server-url      = string
      app-deployed-ns = string
  }))
  description = "ArgoCD applications to install"
}

variable "eso_namespace" {
  type        = string
  description = "Namespace for External Secret Operator"
  default     = "external-secrets"
}

variable "reloader_namespace" {
  type        = string
  description = "Namespace for Reloader and make sure to match with app namespace"
  default     = "default"
}

variable "reloader_create_ns" {
  type        = bool
  description = "Create namespace for Reloader if it doesn't exist"
  default     = false
}

variable "helm_timeout" {
  type        = number
  description = "Timeout for Helm releases in seconds"
  default     = 900
}