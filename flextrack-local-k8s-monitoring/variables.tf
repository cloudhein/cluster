variable "slack_webhook_url" {
  description = "Slack webhook URL for alerting"
  type        = string
  sensitive   = true
}

variable "monitoring_namespace" {
  description = "Namespace for monitoring stack"
  type        = string
  default     = "monitoring"
}

variable "ingress_release_name" {
  description = "Helm release name for nginx ingress"
  type        = string
  default     = "nginx-monitoring"
}

variable "ingressclassresource" {
  description = "Ingress class name"
  type        = string
  default     = "nginx-monitoring"
}

variable "monitoring_release_name" {
  description = "monitoring release name"
  type        = string
  default     = "monitoring"
}