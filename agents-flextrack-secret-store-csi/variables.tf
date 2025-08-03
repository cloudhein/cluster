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
  }))
  description = "ArgoCD applications to install"
}

variable "cluster_name" {
  type        = string
  description = "Name of the cluster"
  default     = "dev-eks-cluster"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}